entity

	/*

		Entities take damage and can be repaired/healed.
		Falling damage is calculated differently than melee damage but can usually be subbed
		in for taking bludgeoning melee damage.

		Death means destruction for items and the leaving of a corpse for living entities.

	*/

	var

		/*

			Damage types include:

			*	Slashing
			*	Bludgeoning
			*	Piercing
			*	Fire
			*	Frost
			*	Sonic
			*	Acid
			*	Electricity

		*/

		list/damage_resistance = list(	"Slashing" 		= 1,\
										"Bludgeoning" 	= 1,\
										"Piercing"		= 1,\
										"Fire"			= 1,\
										"Frost"			= 1,\
										"Sonic"			= 1,\
										"Acid"			= 1,\
										"Electricity"	= 1)

	proc

		take_damage_fall(floors_fallen)

		take_damage(damage_amount, damage_type)
			sub_health(round(damage_amount * damage_resistance[damage_type]))

		death_check() if(health <= 0) death()

		death()

		sub_health(health_amount)
			health -= health_amount
			death_check()

		sub_max_health(health_amount)
			var/old_ratio = health/max_health
			max_health -= health_amount
			health = max_health * old_ratio
			if(health > max_health) health = max_health
			death_check()

		add_health(health_amount)
			health = health_amount + health > max_health ? max_health : health_amount + health

		add_max_health(health_amount)
			var/old_ratio = health/max_health
			max_health += health_amount
			health = max_health * old_ratio