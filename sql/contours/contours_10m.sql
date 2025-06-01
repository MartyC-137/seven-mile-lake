CREATE INDEX IF NOT EXISTS idx_contour_10m_geom
ON seven_mile_lake.contours_10m
USING GIST (geom);

-- mv w/ preserved topology
DROP MATERIALIZED VIEW IF EXISTS seven_mile_lake.contours_10m_mv;
CREATE MATERIALIZED VIEW IF NOT EXISTS seven_mile_lake.contours_10m_mv
AS
SELECT 
    id,
    ST_SimplifyPreserveTopology(geom, 1) AS geom,
    elev
FROM seven_mile_lake.contours_10m;

SELECT * FROM seven_mile_lake.contours_10m_mv;
