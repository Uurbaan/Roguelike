#define DEBUG

world

	New()

		..()
		load_all_templates()

		var/list/l = load_body_struct("raws/body_struct/struct_humanoid.txt")
		var/total_weight	= 0
		var/total_blood		= 0
		var/total_health	= 0

		for(var/body_part/b in l)
			world.log<<b.name
			total_weight+=b.weight
			total_blood+=b.blood
			total_health+=b.max_health
			if(b.name == "ear")
				var/body_part/e = b.connect
				world.log<<"connected to: [e.name]"
		world.log<<total_weight
		world.log<<total_blood
		world.log<<total_health