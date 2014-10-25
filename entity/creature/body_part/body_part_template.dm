proc

	load_body_struct(template_file)

		if(!fexists(template_file))
			world.log << "Template file '[template_file]' does not exist!"
			return null

		var/list/body_struct 		= split_body_struct(file2text(template_file))

		return body_struct

	split_body_struct(file_data)

		var/list/all_flags 	= split(clean_template(file_data), "\n")
		var/list/ret		= new
		var/body_part/current_part

		for(var/i = 1, i<=all_flags.len, i++)

			var/flag = all_flags[i]
			if(!flag) continue
			flag = replace(flag, "&s", " ")

			var/list/split_flag 	= split(flag, ":")
			var/var_name			= split_flag[1]
			var/var_value			= split_flag[2]

			if(var_name == "id")
				if(current_part)
					current_part.max_health = current_part.health
					ret.Add(current_part.id)
					ret[current_part.id] = current_part
				current_part = new/body_part

			else if(var_value == "true") var_value = TRUE
			else if(var_value == "false") var_value = FALSE
			else if(findtext(var_value, ";"))
				var/list/var_list = params2list(var_value)
				for(var/j = 1, j<=var_list.len, j++)
					var/val = var_list[j]
					var/val_map
					if(var_list[val])
						val_map = var_list[val]
					if(isnum(text2num(val)))
						val = text2num(val)
					if(val_map && isnum(text2num(val_map)))
						val_map = text2num(val_map)
					if(val_map)
						var_list[j] = val
						var_list[var_list[j]] = val_map
					else
						var_list[j] = val

				var_value = var_list
			else if(isnum(text2num(var_value)))
				var_value = text2num(var_value)

			if(current_part.vars.Find(var_name))
				if(var_name == "connect")
					var_value = ret[var_value]
				current_part.vars[var_name] = var_value

		if(current_part)
			current_part.max_health = current_part.health
			ret.Add("lastpart")
			ret["lastpart"] = current_part

		var/list/constructed_body = new
		for(var/t in ret)
			constructed_body.Add(ret[t])

		return constructed_body