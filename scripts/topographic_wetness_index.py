import os
from pathlib import Path
import whitebox

wbt = whitebox.WhiteboxTools()

REPO_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = REPO_ROOT / "data" / "digital_elevation_models"

raw_dem         = str(DATA_DIR / "dem_phase1.tif")
smooth_dem      = str(DATA_DIR / "dem_smoothed.tif")
conditioned_dem = str(DATA_DIR / "dem_breached.tif")
slope_raster    = str(DATA_DIR / "slope.tif")
slope_adjusted  = str(DATA_DIR / "slope_adjusted.tif")
flow_accum      = str(DATA_DIR / "flow_accumulation.tif")
twi_output      = str(DATA_DIR / "twi_output.tif")

print("🚀 Running Upgraded Wetland-Focused Pipeline...")

# Step 1: Smooth micro-noise
print(" -> Smoothing DEM...")
wbt.gaussian_filter(raw_dem, smooth_dem, sigma=2.0)

# Step 2: Hydrological Correction
print(" -> Breaching depressions cleanly...")
wbt.breach_depressions_least_cost(dem=smooth_dem, output=conditioned_dem, dist=100, fill=True)

# Step 3: Slope calculation (Degrees)
print(" -> Calculating slope in DEGREES...")
wbt.slope(conditioned_dem, slope_raster, units="degrees")

# Step 3.5: Add a tiny offset to slope to prevent 0-degree NoData gaps in flat wetlands
print(" -> Nudging flat slopes to prevent NoData transparency holes...")
wbt.add(slope_raster, 0.01, slope_adjusted)

# Step 4: Multi-Directional Flow Accumulation (FD8)
# This forces water to spread out across wide flat wetlands instead of collapsing into lines.
print(" -> Computing MFD (FD8) cell flow accumulation...")
wbt.fd8_flow_accumulation(conditioned_dem, flow_accum, "cells", 1.1)

# Step 5: TWI Computation (Passing strictly positionally)
print(" -> Computing Topographic Wetness Index...")
wbt.wetness_index(flow_accum, slope_adjusted, twi_output)

print(f"\n✅ Pipeline completed! Refresh QGIS (F5).")