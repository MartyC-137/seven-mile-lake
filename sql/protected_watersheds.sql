-- Create index
-- DROP INDEX IF EXISTS seven_mile_lake.idx_watercourses_geom;
CREATE INDEX IF NOT EXISTS idx_watercourses_geom
ON seven_mile_lake.watercourses
USING GIST (geom);

-- mv w/ preserved topology
-- DROP MATERIALIZED VIEW IF EXISTS seven_mile_lake.watercourses_mv;
CREATE MATERIALIZED VIEW IF NOT EXISTS seven_mile_lake.watercourses_mv
AS
SELECT 
    id,
    ST_SimplifyPreserveTopology(geom, 1) AS geom,
    name1
FROM seven_mile_lake.watercourses;

SELECT * FROM seven_mile_lake.watercourses_mv;