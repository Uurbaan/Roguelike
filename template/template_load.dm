var

	list/templates	= new
	list/materials 	= new

proc

	load_all_templates()

		// Loading material templates

		var/list/file_list = flist("raws/mat/")
		for(var/f in file_list)
			var/template/new_template = load_template("raws/mat/[f]")
			if(new_template)
				var/material/new_mat  = new
				for(var/k in new_template.data)
					if(k == "type" || k == "id")
						continue
					new_mat.vars[k] = new_template.data[k]
					materials.Add(new_mat.name)
					materials[new_mat.name] = new_mat

		// Loading all other templates.

		file_list = flist("raws/") - flist("raws/mat/") - flist("raws/body_struct")
		for(var/f in file_list)
			if(findtext(f, "/mat/")) continue
			load_template("raws/[f]")

	load_template(template_file)

		if(!fexists(template_file))
			world.log << "Template file '[template_file]' does not exist!"
			return null

		var/list/template_data 		= split_template(file2text(template_file))
		var/template/new_template 	= new
		new_template.id				= template_data["id"]
		new_template.data.Add(template_data)
		if(templates.Find(new_template.id))
			world.log << "There already exists a template with id '[new_template.id]'!"
			return null
		else
			templates.Add(new_template.id)
			templates[new_template.id] = new_template
			return new_template

	split_template(file_data)

		var/list/all_flags 	= split(clean_template(file_data), "\n")
		var/list/ret		= new

		for(var/i = 1, i<=all_flags.len, i++)

			var/flag = all_flags[i]
			if(!flag) continue
			flag = replace(flag, "&s", " ")

			var/list/split_flag 	= split(flag, ":")
			var/var_name			= split_flag[1]
			var/var_value			= split_flag[2]

			if(var_value == "true") var_value = TRUE
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

			ret.Add(var_name)
			ret[var_name] = var_value

		return ret

	clean_template(file_data)
		file_data = replace(file_data, " ", "")
		file_data = replace(file_data, "\t", "")
		return file_data