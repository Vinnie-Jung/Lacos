class_name SkillHandler
extends Node

# Character
@onready var current_character: CharacterBody2D

# Mother Publics
@export var can_melee: bool = true
@export var can_ranged: bool = true
@export var can_dash: bool = true

# Daughter Publics
@export var is_inv: bool = false
@export var can_use_skill: bool = true
@export var can_shield: bool = true
@export var can_hide: bool = true
@export var can_purify: bool = true

# Skills
@onready var rock_unlocked: bool = true
@onready var spear_unlocked: bool = false
@onready var ranged_unlocked: bool = false
@onready var dash_unlocked: bool = false
@onready var super_jump_unlocked: bool = true
@onready var shield_unlocked: bool = false
@onready var invisibility_unlocked: bool = false
@onready var purify_unlocked: bool = false

# Timers
@onready var melee_cd_exists: bool = false
@onready var ranged_cd_exists: bool = false
@onready var dash_duration_exists: bool = false
@onready var dash_cooldown_exists: bool = false
@onready var shield_duration_exists: bool = false
@onready var shield_cd_exists: bool = false
@onready var invisibility_duration_exists: bool = false
@onready var invisibility_cd_exists: bool = false
@onready var purify_duration_exists: bool = false
@onready var purify_cd_exists: bool = false
@onready var cooldown: CooldownHandler = CooldownHandler.new()

func _process(_delta: float) -> void:
	var current_scene = Scenehandler.current_scene
	if (current_scene != null && current_scene.name != "MainMenu"):
		var player_exist = current_scene.has_node("Player")
		if (player_exist):
			current_character = current_scene.get_node("Player")
			if (current_scene.get_node("Player").is_in_group("mother")):
				shield_cd_exists = false
				shield_duration_exists = false
				invisibility_cd_exists = false
				invisibility_duration_exists = false
				purify_cd_exists = false
			else:
				melee_cd_exists = false
				ranged_cd_exists = false
				dash_duration_exists = false
				dash_cooldown_exists = false

# --- MOTHER ---
func dash(dir: float, delta: float = get_physics_process_delta_time()) -> void:
	can_dash = false
	current_character.is_dashing = true
	var dash_speed: int = 150000 # 6x character default speed
	current_character.velocity.x = dir * (dash_speed * delta)
	
	# Sets timer
	dash_duration_exists = cooldown.handle_timer("DashDuration", dash_duration_exists, current_character)

func melee_attack(area: CollisionShape2D, dir: int, animation: AnimatedSprite2D) -> void:
	# Attack Area
	area.disabled = false
	area.position.x = -29.5 if (dir <0) else 29.5
	
	# Attack Animation
	animation.flip_h = true if (dir < 0) else false
	animation.play("spear_attack")
	
	# Sets attack status
	current_character.can_attack_melee = false
	current_character.is_attacking = true
	
	can_melee = false
	
	# Sets timer
	melee_cd_exists = cooldown.handle_timer("MeleeCooldown", melee_cd_exists, current_character)
	
func ranged_attack(dir: int) -> void:
	# Create a projectile instance
	var new_proj = preload("res://scenes/extras/projectiles/mother_projectile.tscn")
	new_proj = new_proj.instantiate()
	
	# Adds projectile to the level
	current_character.get_parent().add_child(new_proj)
	
	# Sets projectile attributes
	new_proj.position = current_character.position
	new_proj.direction.x = dir
	new_proj.scale = Vector2(0.3, 0.3)
	new_proj.damage = PlayerAttrib.ranged_dmg
	
	# Sets attack status
	current_character.can_attack_ranged = false
	can_ranged = false
	
	# Sets timer
	ranged_cd_exists = cooldown.handle_timer("RangedCooldown", ranged_cd_exists, current_character)

# --- DAUGHTER ---
func shield() -> void:
	can_use_skill = false
	
	# Setting shield properties
	var new_shield = Node2D.new()
	new_shield.name = "ShieldGenerated"
	
	current_character.add_child(new_shield)
	current_character.modulate = Color(0, 0, 1)
	
	# Sets timer
	shield_duration_exists = cooldown.handle_timer("ShieldDuration", shield_duration_exists, current_character)

func destroy_shield(node: Node2D) -> void:
	node.queue_free()
	
func invisibility() -> void:
	can_use_skill = false
	is_inv = true
	can_hide = false
	current_character.modulate = Color(1, 1, 1, 0.4)
	
	# Sets timer
	invisibility_duration_exists = cooldown.handle_timer("InvisibilityDuration", invisibility_duration_exists, current_character)
	
func purify() -> void:
	can_use_skill = false
	can_purify = false
	
	#current_character._animation("purify")	
	current_character.modulate = Color(0,1,0.4, 0.5)
	

	# Sets timer
	purify_duration_exists = cooldown.handle_timer("PurifyDuration", purify_duration_exists, current_character)


# --- COOLDOWNS ---
func dash_ends() -> void:
	current_character.is_dashing = false
	# Sets timer
	dash_cooldown_exists = cooldown.handle_timer("DashCooldown", dash_cooldown_exists, current_character)
	
func dash_cooldown() -> void:
	can_dash = true
	
func melee_attack_cooldown() -> void:
	current_character.can_attack_melee = true
	current_character.is_attacking = false
	current_character.spear_attack_area.disabled = true
	current_character.rock_box.disabled = true
	can_melee = true
	
func ranged_attack_cooldown() -> void:
	current_character.can_attack_ranged = true
	can_ranged = true
	
func shield_ends() -> void:
	can_shield = false
	
	# If finds shield in tree, destroy it!
	for child in current_character.get_children():
		if (child.name == "ShieldGenerated"):
			destroy_shield(child)
	current_character.modulate = Color(1, 1, 1)
	can_use_skill = true
	
	# Sets timer
	shield_cd_exists = cooldown.handle_timer("ShieldCooldown", shield_cd_exists, current_character)
	
func shield_cooldown() -> void:
	can_shield = true
	
func invisibility_ends() -> void:
	is_inv = false
	current_character.modulate = Color(1, 1, 1, 1)
	can_use_skill = true
	
	# Sets timer
	invisibility_cd_exists = cooldown.handle_timer("InvisibilityCooldown", invisibility_cd_exists, current_character)
	
func invisibility_cooldown() -> void:
	can_hide = true

func purify_ends() -> void:
	can_use_skill = true
	current_character.modulate = Color(1,1,1,1)
	
	# Sets timer
	purify_cd_exists = cooldown.handle_timer("PurifyCooldown", purify_cd_exists, current_character)
func purify_cooldown() -> void:
	can_purify = true

# --- Progress ---
func unlock_skill(skill: String) -> void:
	match skill:
		"rock_attack":
			print("Level Up!!! You unlocked ROCK ATTACK")
			rock_unlocked = true
		"spear_attack":
			print("Level Up!!! You unlocked SPEAR ATTACK")
			spear_unlocked = true
		"ranged_attack":
			print("Level Up!!! You unlocked RANGED ATTACK")
			ranged_unlocked = true
		"dash":
			print("Level Up!!! You unlocked DASH skill")
			dash_unlocked = true
		"shield":
			print("Level Up!!! You unlocked SHIELD skill")
			shield_unlocked = true
		"invisibility":
			print("Level Up!!! You unlocked INVISIBILITY skill")
			invisibility_unlocked = true
		"purify":
			print("Level Up!!! You unlocked PURIFY skill")
			purify_unlocked = true
		_:
			pass



func _input(event: InputEvent) -> void:
	if (event is InputEventKey):
		if (event.is_action_pressed("ui_right")):
			unlock_skill("purify")
		if (event.is_action_pressed("ui_home")):
			unlock_skill("ranged_attack")
			
		if (event.is_action_pressed("ui_left")):
			unlock_skill("dash")
		'''
		if (event.is_action_pressed("ui_right")):
			unlock_skill("shield")
		'''
		if (event.is_action_pressed("ui_down")):
			unlock_skill("invisibility")
			
		if (event.is_action_pressed("ui_up")):
			unlock_skill("ranged_attack")

