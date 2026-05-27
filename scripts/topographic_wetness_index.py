import os
import whitebox

# Initialize the WhiteboxTools runner
wbt = whitebox.WhiteboxTools()

# Set your project directory and file names
data_dir = "/Users/martinpalkovic/Documents/repos/seven-mile-lake/data/digital_elevation_models"  # Change this to your directory
raw_dem = os.path.join(data_dir, "dem_phase1.tif")
conditioned_dem = os.path.join(data_dir, "dem_breached.tif")
slope_raster = os.path.join(data_dir, "slope.tif")
flow_accum = os.path.join(data_dir, "flow_accumulation.tif")
twi_output = os.path.join(data_dir, "twi_output.tif")

print("🚀 Starting Terrain Analysis Pipeline...")

# Step 1: Hydrological Correction (Breach Depressions)
# Real landscapes have depressions, but raw DEMs have "digital sinks" that trap water.
# Breaching carves a subtle path through artificial blockages so water flows continuously.
print(" -> Enforcing hydrologic flow patterns (Breaching depressions)...")
wbt.breach_depressions(dem=raw_dem, output=conditioned_dem)

# Step 2: Calculate Slope (Required in degrees for TWI)
print(" -> Calculating slope...")
wbt.slope(dem=conditioned_dem, output=slope_raster, units="degrees")

# Step 3: D-Infinity Flow Accumulation (Specific Contributing Area)
# SAGA uses D8 (8-directional), which forces water into artificial straight lines.
# Whitebox's D-Infinity allows water to split across multiple cells for natural tracking.
print(" -> Computing multi-directional flow accumulation...")
wbt.d_inf_flow_accumulation(conditioned_dem, flow_accum, out_type="specific contributing area")

# Step 4: Calculate Topographic Wetness Index (TWI)
print(" -> Computing Topographic Wetness Index...")
wbt.wetness_index(sca=flow_accum, slope=slope_raster, output=twi_output)

print(f"✅ Success! Your TWI file is ready at: {twi_output}")
print("Drag this into QGIS and apply a 'Blues' singleband pseudocolor ramp.")