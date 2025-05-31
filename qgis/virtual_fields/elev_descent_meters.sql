/* QGIS virtual field for calculating total elevation descent of a polyline */
with_variable('elev_descent', 0,
    array_sum(
        array_foreach(
            generate_series(1, num_points($geometry)-1),
            max(0, raster_value('dem_phase1_earth', 1, point_n($geometry, @element)) - raster_value('dem_phase1_earth', 1, point_n($geometry, @element+1)))
        )
    )
)
