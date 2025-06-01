-- Create index
-- DROP INDEX IF EXISTS seven_mile_lake.idx_protected_natural_areas_geom;
CREATE INDEX IF NOT EXISTS idx_protected_natural_areas_geom
ON seven_mile_lake.protected_natural_areas
USING GIST (geom);

-- mv w/ preserved topology
-- DROP MATERIALIZED VIEW IF EXISTS seven_mile_lake.protected_natural_areas_mv;
CREATE MATERIALIZED VIEW IF NOT EXISTS seven_mile_lake.protected_natural_areas_mv
AS
SELECT 
    id,
    ST_SimplifyPreserveTopology(geom, 1) AS geom,
    name1
FROM seven_mile_lake.protected_natural_areas;

SELECT * FROM seven_mile_lake.protected_natural_areas_mv;