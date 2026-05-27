import os
from pathlib import Path
import whitebox

# Initialize the WhiteboxTools runner
wbt = whitebox.WhiteboxTools()

# Locate paths relative to this script's execution context
# __file__ is /Users/.../seven-mile-lake/scripts/twi_pipeline.py
# .parents[1] climbs up two levels to the repo root: /seven-mile-lake/
REPO_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = REPO_ROOT / "data" / "digital_elevation_models"

# Ensure the data directory actually exists before running
DATA_DIR.mkdir(parents=True, exist_ok=True)

# Define all I/O targets cleanly as Path objects
raw_dem         = DATA_DIR / "dem_phase1.tif"
smooth_dem      = DATA_DIR / "dem_smoothed.tif"
conditioned_dem = DATA_DIR / "dem_breached.tif"
slope_raster    = DATA_DIR / "slope.tif"
flow_accum      = DATA_DIR / "flow_accumulation.tif"
twi_output      = DATA_DIR / "twi_output.tif"

print("🚀 Starting Refined Terrain Analysis Pipeline...")

# Step 1: Smooth the DEM to drop micro-noise
print(" -> Smoothing DEM...")
wbt.gaussian_filter(input=str(raw_dem), output=str(smooth_dem), sigma=2.0)

# Step 2: Hydrological Correction
print(" -> Enforcing hydrologic flow paths...")
wbt.breach_depressions(dem=str(smooth_dem), output=str(conditioned_dem))

# Step 3: Slope calculation (Degrees for Whitebox)
print(" -> Calculating slope in DEGREES...")
wbt.slope(dem=str(conditioned_dem), output=str(slope_raster), units="degrees")

# Step 4: Flow Accumulation
print(" -> Computing flow accumulation...")
wbt.d_inf_flow_accumulation(input=str(conditioned_dem), output=str(flow_accum), out_type="specific contributing area")

# Step 5: TWI Computation
print(" -> Computing Topographic Wetness Index...")
wbt.wetness_index(sca=str(flow_accum), slope=str(slope_raster), output=str(twi_output))

print(f"\n✅ Pipeline completed successfully!")
print(f"Artifacts stored cleanly inside: {DATA_DIR}")