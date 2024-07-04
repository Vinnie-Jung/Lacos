class_name CooldownHandler
extends Node

func handle_timer(timer_name: String, exist: bool, character: CharacterBody2D) -> bool:
	var timer: Timer
	
	if (character.is_in_group("daughter")):
		match timer_name:
			"ShieldDuration":
				if (!exist):
					exist = true
					timer = create_timer(timer_name, 3.0)					
					timer.timeout.connect(Skillhandler.shield_ends)
					character.add_child(timer)
				else:
					timer = character.get_node(timer_name)
					
				timer.start()
			
			"ShieldCooldown":
				if (!exist):
					exist = true
					timer = create_timer(timer_name, 5.0)
					timer.timeout.connect(Skillhandler.shield_cooldown)
					character.add_child(timer)
				else:
					timer = character.get_node(timer_name)
				
				timer.start()
				
			"InvisibilityDuration":
				if (!exist):
					exist = true
					timer = create_timer(timer_name, 4.0)
					timer.timeout.connect(Skillhandler.invisibility_ends)
					character.add_child(timer)
				else:
					timer = character.get_node(timer_name)
				
				timer.start()
				
			"InvisibilityCooldown":
				if (!exist):
					exist = true
					timer = create_timer(timer_name, 10.0)
					timer.timeout.connect(Skillhandler.invisibility_cooldown)
					character.add_child(timer)
				else:
					timer = character.get_node(timer_name)
				
				timer.start()
			
			_:
				pass
	
	else:
		match timer_name:
			"MeleeCooldown":
				if (!exist):
					exist = true
					timer = create_timer(timer_name, 0.4)
					timer.timeout.connect(Skillhandler.melee_attack_cooldown)
					character.add_child(timer)
				else:
					timer = character.get_node(timer_name)
				
				timer.start()
				
			"RangedCooldown":
				if (!exist):
					exist = true
					timer = create_timer(timer_name, 1.0)
					timer.timeout.connect(Skillhandler.ranged_attack_cooldown)
					character.add_child(timer)
				else:
					timer = character.get_node(timer_name)
				
				timer.start()
				
			"DashDuration":
				if (!exist):
					exist = true
					timer = create_timer(timer_name, 0.05)
					timer.timeout.connect(Skillhandler.dash_ends)
					character.add_child(timer)
				else:
					timer = character.get_node(timer_name)
				
				timer.start()
				
			"DashCooldown":
				if (!exist):
					exist = true
					timer = create_timer(timer_name, 1.0)
					timer.timeout.connect(Skillhandler.dash_cooldown)
					character.add_child(timer)
				else:
					timer = character.get_node(timer_name)
				
				timer.start()
				
			_:
				pass
				
	return exist
		
func create_timer(timer_name: String, time) -> Timer:
	var new_timer: Timer = Timer.new()
	new_timer.name = timer_name
	new_timer.wait_time = time
	new_timer.one_shot = true
	new_timer.autostart = false
	
	return new_timer
