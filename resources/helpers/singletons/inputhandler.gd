class_name InputHandler
extends Node

var player: CharacterBody2D

func _process(_delta: float) -> void:
	if (Scenehandler.current_scene != null):
		player = Scenehandler.current_scene.find_child("Player")

func _input(event: InputEvent) -> void:
	if (player == null):
		return
	# If is a mouse button action
	if (event is InputEventMouseButton):
		if (player.is_in_group("mother")):
			if (event.is_action_pressed("melee_attack") && can_use(Skillhandler.can_melee)):
				Skillhandler.spear_unlocked = true # (TODO) REMOVE IT
				if (Skillhandler.spear_unlocked):
					var attack_box: CollisionShape2D = PlayerAttrib.attack_box
					var direction: int = PlayerAttrib.direction
					var animation: AnimatedSprite2D = PlayerAttrib.animation
					Skillhandler.melee_attack(attack_box, direction, animation)
				else:
					# Rock
					pass
					
			if (event.is_action_pressed("ranged_attack") && can_use(Skillhandler.can_ranged)):
				if (Skillhandler.ranged_unlocked):
					var direction: int = PlayerAttrib.direction
					Skillhandler.ranged_attack(direction)
		
		elif (player.is_in_group("daughter")):
			if (event.is_action_pressed("purify_skill") && can_use(Skillhandler.can_purify)):
				if (Skillhandler.purify_unlocked):
					Skillhandler.purify()
	
	# If is a keyboard action
	elif (event is InputEventKey):
		# --- Mother ---
		if (event.is_action_pressed("dash") && can_use(Skillhandler.can_dash)):
			if (Skillhandler.dash_unlocked):
				var direction: int = PlayerAttrib.dash_direction
				Skillhandler.dash(direction)
		
		# --- Daughter ---
		if (event.is_action_pressed("shield_skill") && can_use(Skillhandler.can_shield)):
			if (Skillhandler.shield_unlocked):
				Skillhandler.shield()
				
		if (event.is_action_pressed("invisibility_skill") && can_use(Skillhandler.can_hide)):
			if (Skillhandler.invisibility_unlocked):
				Skillhandler.invisibility()
				
		
# Verifies if skill can be used
func can_use(skill: bool) -> bool:
	if (player != null):
		if (Skillhandler.can_use_skill && skill):
			return true
		else:
			return false
	else:
		return false
	
