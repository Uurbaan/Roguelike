var/map_handler/map	= new

map_handler

	var

		list/terrain_array	= new
		current_file

	proc

		get_terrain(xloc, yloc, zloc)
			if(terrain_array.Find("[xloc],[yloc],[zloc]"))
				return terrain_array["[xloc],[yloc],[zloc]"]
			else
				return new/terrain/sky

		get_circle(xloc, yloc, zloc, radius)
			var/list/ret = new
			for(var/terrain/t in get_cube(xloc,yloc,zloc,round(radius/2)+1))
				if(sqrt((t.xloc-xloc)**2+(t.yloc-yloc)**2) <= radius)
					ret.Add(t)
			return ret

		get_cube(xloc, yloc, zloc, size)
			var/list/ret = new
			for(var/i=xloc-size, i<=xloc+size, i++)
				for(var/j=yloc-size, j<=yloc+size, j++)
					if(terrain_array.Find("[i],[j]"))
						ret.Add(terrain_array["[i],[j]"])
			return ret