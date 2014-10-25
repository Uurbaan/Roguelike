entity

	/*

		Type entity extends all possible things that can be saved on the map.
		Entities have location, weight, names, and not much else.  Entities can also move
		and take damage and have health.

	*/

	var

		name
		name_plural

		weight

		health
		max_health

		xloc
		yloc
		zloc

		terrain/current_terrain

		can_move

	proc

		create(list/templates)

		set_loc(new_x, new_y, new_z, terrain/t)

			if(!t) t = map.get_terrain(new_x, new_y, new_z)

			xloc 				= new_x
			yloc 				= new_y
			zloc 				= new_z
			current_terrain 	= t

		move(direction, steps=1)
			if(take_step(direction) && steps-1 > 0)
				move(direction, steps--)

		take_step(direction)

			if(!can_move) return FALSE

			var/next_xloc = xloc + (direction == WEST  ? -1 : (direction == EAST  ? 1 : 0))
			var/next_yloc = yloc + (direction == SOUTH ? -1 : (direction == NORTH ? 1 : 0))
			var/next_zloc = zloc

			var/terrain/terrain_next = map.get_terrain(next_xloc, next_yloc, zloc)

			if(terrain_next.is_wall)
				if(current_terrain.is_slope)
					var/terrain/terrain_above = map.get_terrain(next_xloc, next_yloc, next_zloc+1)
					if(!terrain_above.is_wall)
						terrain_next = terrain_above
						next_zloc++
					else
						return FALSE
				else
					return FALSE
			else
				while(!terrain_next.is_floor)
					next_zloc--
					terrain_next = map.get_terrain(next_xloc, next_yloc, next_zloc)

				if(zloc != next_zloc)
					take_damage_fall(zloc-next_zloc)

			set_loc(next_xloc, next_yloc, next_zloc, terrain_next)

			return TRUE

