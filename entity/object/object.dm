object

	parent_type 			= /entity
	can_move				= TRUE

	/*

		create() format
		Object template, all material templates

	*/

	var

		value				= 0

		stack				= 0
		max_stack			= 0

		list/materials
		list/material_makeup

		melee_modifier		= -5
		range_modifier		= -5
		damage_roll			= "1d2"
		damage_modifier		= 0
		damage_type			= "Bludgeoning"
		damage_roll_throw	= "1d2"
		damage_modifier_throw=-5

		is_wearable			= FALSE
		armor_modifier		= 0

	proc

		is_worn() return health <= max_health/4