-- Create index
-- DROP INDEX IF EXISTS seven_mile_lake.idx_wetlands_geom;
CREATE INDEX IF NOT EXISTS idx_wetlands_geom
ON seven_mile_lake.wetlands
USING GIST (geom);

-- mv w/ preserved topology
-- DROP MATERIALIZED VIEW IF EXISTS seven_mile_lake.wetlands_mv;
CREATE MATERIALIZED VIEW IF NOT EXISTS seven_mile_lake.wetlands_mv
AS
SELECT 
    id,
    ST_SimplifyPreserveTopology(geom, 1) AS geom,
    shapearea
FROM seven_mile_lake.wetlands;

SELECT * FROM seven_mile_lake.wetlands_mv;