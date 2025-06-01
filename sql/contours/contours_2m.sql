-- Create index
CREATE INDEX idx_contour_2m_geom
ON seven_mile_lake.contours_2m
USING GIST (geom);

-- mv w/ preserved topology
-- DROP MATERIALIZED VIEW IF EXISTS seven_mile_lake.contours_2m_mv;
CREATE MATERIALIZED VIEW seven_mile_lake.contours_2m_mv
AS
SELECT 
    id,
    ST_SimplifyPreserveTopology(geom, 1) AS geom,
    elev
FROM seven_mile_lake.contours_2m;

SELECT * FROM seven_mile_lake.contours_2m_mv;
