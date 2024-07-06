class_name Mother
extends CharacterBody2D

# Nodes
@onready var animation: AnimatedSprite2D = $Texture
@onready var spear_attack_area: CollisionShape2D = $SpearAttackBox/Spear
@onready var rock_box = $RockAttackBox/Rock

# Cooldowns
@onready var melee_cooldown: Timer = $SpearAttackBox/AttackCooldown
@onready var hit_cooldown: Timer = $HurtCooldown
@onready var can_be_hit: Timer = $CanHurtAgainCooldown
@onready var rock_cooldown: Timer = $RockAttackBox/AttackCooldown

# Preloads
@onready var daughter_scene: PackedScene = preload("res://scenes/levels/level_1_1.tscn")
@onready var death_screen: PackedScene = preload("res://scenes/ui/death_screen/death_screen.tscn")

# Enviroment
@onready var gravity: int = 1200

# Character Attributes
@onready var max_health: int = 20
@onready var current_health: int = max_health
@onready var is_jumping: bool = false
@onready var is_falling: bool = false
const SPEED: int = 25000
const JUMP_STRENGH: int = 700
var can_be_hurt: bool = true

# Publics
@export var can_attack_ranged = true
@export var can_attack_melee = true
@export var is_attacking: bool = false
@export var is_dashing: bool = false

# Auxs
@onready var dash_dir: float
@onready var delta_time: float

func _ready() -> void:
	# Sets handler
	PlayerAttrib.character = "mother"
	PlayerAttrib.set_max_health(max_health)
	PlayerAttrib.set_health(current_health)
	PlayerAttrib.scale = self.scale
	
	# Sets initial animation
	animation.play("idle")

	# Sets groups
	self.add_to_group("player")
	self.add_to_group("mother")
	
	# Changes node name
	self.name = "Player"

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		var dir: int = get_attack_direction()
		PlayerAttrib.direction = dir

func _physics_process(delta: float) -> void:
	move(delta)
	
	# Applies gravity
	self.velocity.y += gravity * delta

func move(delta: float) -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	
	dash_dir = direction
	PlayerAttrib.dash_direction = dash_dir
	delta_time = delta
	
	if (!is_dashing):
		self.velocity.x = direction * (SPEED * delta)
	
	# Controls the animation
	if (direction != 0 && !is_jumping && !is_falling && !is_attacking):
		animation.play("walk")
		animation.flip_h = true if (direction < 0) else false
		spear_attack_area.position.x = -29.5 if (direction <0) else 29.5
		rock_box.position.x = -29.5 if (direction <0) else 29.5
	elif (is_jumping && !is_attacking):
		animation.play("falling")
		if (direction < 0):
			animation.flip_h = true
		elif (direction > 0):
			animation.flip_h = false
		else:
			pass
			
		spear_attack_area.position.x = -29.5 if (direction < 0 || animation.flip_h) else 29.5
		rock_box.position.x = -29.5 if (direction <0) else 29.5
	elif (is_falling && !is_attacking):
		animation.play("falling")
		if (direction < 0):
			animation.flip_h = true
		elif (direction > 0):
			animation.flip_h = false
		else:
			pass
	elif (!is_attacking):
		animation.play("idle")
	
	# Verifies jump
	verify_jump()
	move_and_slide()
	
	PlayerAttrib.position = self.position
	PlayerAttrib.attack_box = spear_attack_area if (Skillhandler.spear_unlocked) else rock_box
	PlayerAttrib.animation = animation

func verify_jump() -> void:
	if (Input.is_action_pressed("jump") && is_on_floor()):
		self.velocity.y = -JUMP_STRENGH
		is_jumping = true
		
	elif (!is_on_floor()):
		is_jumping = true
		if (self.velocity.y > 0):
			is_jumping = false
			is_falling = true
	else:
		is_jumping = false
		is_falling = false
		
func take_damage(dmg: int) -> void:
		if (can_be_hurt):
			can_be_hurt = false
			can_be_hit.start()
			current_health -= dmg
			PlayerAttrib.set_health(current_health)
			
			self.modulate = Color(1,0,0)
			hit_cooldown.start()
			if (current_health <= 0):
				call_deferred("die")

func hurt_cooldown() -> void:
	self.modulate = Color(1,1,1)
	
func die() -> void:
	Soulhandler.reset_soul_counter()
	var death_box = death_screen.instantiate()
	self.get_parent().add_child(death_box)
	self.queue_free()

func _on_attack_box_body_entered(body):
	aa(body)
	
func aa(body):
	can_attack_melee = false
	if (body.is_in_group("enemies")):
		if (Skillhandler.spear_unlocked):
			body.take_damage(PlayerAttrib.spear_dmg)
		else:
			body.take_damage(PlayerAttrib.rock_dmg)
	
func get_attack_direction() -> int:
	# Gets mouse position
	var mouse_position = get_viewport().get_camera_2d().get_global_mouse_position()
	var attack_dir: int = 0 
	
	# Defines if direction is left or right
	if (mouse_position.x < self.global_position.x):
		attack_dir = -1
	else:
		attack_dir = 1
		
	return attack_dir


func _on_can_hurt_again_cooldown_timeout():
	can_be_hurt = true


func _on_rock_attack_box_body_entered(body):
	aa(body)
