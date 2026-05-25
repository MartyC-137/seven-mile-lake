with_variable('highway_layer', 'forestry_roads_aoi',
with_variable('w', 12,   -- 1. Gap width (Adjust this so walls sit perfectly outside the highway lanes)
with_variable('l', 16,   -- 2. Wall length along the highway
with_variable('e', 4,    -- 3. Length of the turned-out angled end-caps

-- Grab the nearest road feature within 100 meters
with_variable('nearest_road', array_first(overlay_nearest(@highway_layer, $currentfeature, max_distance:=100)),

if(@nearest_road IS NOT NULL,
  -- We add pi()/2 (90 degrees) here to flip the base alignment to match the road direction
  with_variable('ang', 
    line_interpolate_angle(
      geometry(@nearest_road),
      line_locate_point(geometry(@nearest_road), $geometry)
    ) + pi()/2, 
    
    collect_geometries(
      -- LEFT UNDERPASS WALL WITH END CAPS
      make_line(
        -- Left wall start point
        project(project($geometry, @w, @ang - pi()/2), @l, @ang),
        -- Left wall end point
        project(project($geometry, @w, @ang - pi()/2), @l, @ang + pi())
      ),
      -- Left Top End Cap (angled out 45 deg)
      make_line(
        project(project($geometry, @w, @ang - pi()/2), @l, @ang),
        project(project(project($geometry, @w, @ang - pi()/2), @l, @ang), @e, @ang - pi()/4)
      ),
      -- Left Bottom End Cap (angled out 45 deg)
      make_line(
        project(project($geometry, @w, @ang - pi()/2), @l, @ang + pi()),
        project(project(project($geometry, @w, @ang - pi()/2), @l, @ang + pi()), @e, @ang + 5*pi()/4)
      ),

      -- RIGHT UNDERPASS WALL WITH END CAPS
      make_line(
        -- Right wall start point
        project(project($geometry, @w, @ang + pi()/2), @l, @ang),
        -- Right wall end point
        project(project($geometry, @w, @ang + pi()/2), @l, @ang + pi())
      ),
      -- Right Top End Cap (angled out 45 deg)
      make_line(
        project(project($geometry, @w, @ang + pi()/2), @l, @ang),
        project(project(project($geometry, @w, @ang + pi()/2), @l, @ang), @e, @ang + pi()/4)
      ),
      -- Right Bottom End Cap (angled out 45 deg)
      make_line(
        project(project($geometry, @w, @ang + pi()/2), @l, @ang + pi()),
        project(project(project($geometry, @w, @ang + pi()/2), @l, @ang + pi()), @e, @ang - 5*pi()/4)
      )
    )
  ),
  -- Fallback line
  make_line(project($geometry, 10, 0), project($geometry, 10, pi()))
))))))