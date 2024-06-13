class_name Mother
extends CharacterBody2D

# Nodes
@onready var rock_attack_area = $RockAttackBox/Area
@onready var rock_attack_timer: Timer = $RockAttackBox/AttackTimer
@onready var spear_attack_timer: Timer = $SpearAttackBox/AttackTimer
@onready var animation: AnimatedSprite2D = $Texture
@onready var spear_attack_area = $SpearAttackBox/Area
@onready var hit_timer: Timer = $TakeDamageTimer

# Preloads
@onready var daughter_scene: PackedScene = preload("res://scenes/levels/daugher_scene_prot.tscn")

# World
@onready var gravity = 1200

# Character Attributes
@onready var max_health: int = 10
@onready var current_health: int = max_health
@onready var damage: int = 3
const SPEED: int = 25000
const JUMP_STRENGH: int = 700
var is_jumping: bool

var can_attack = true
var is_attacking: bool = false
var attack_dir

func _ready() -> void:
	# Sets handler
	PlayerAttrib.set_max_health(max_health)
	PlayerAttrib.set_health(current_health)
	
	# Sets initial animation
	_animation("idle")
	
	is_jumping = false

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		if (event.is_action_pressed("melee_attack") && can_attack):
			var mouse_position = get_viewport().get_camera_2d().get_global_mouse_position()
			if (mouse_position.x < global_position.x):
				attack_dir = -1
			else:
				attack_dir = 1
				
			# (TODO) Validate here with weapon player is using
			_spear_attack(attack_dir)
			
		elif (event.is_action_pressed("ranged_attack") && can_attack):
			var mouse_position = get_viewport().get_camera_2d().get_global_mouse_position()
			if (mouse_position.x < global_position.x):
				attack_dir = -1
			else:
				attack_dir = 1
			# (TODO) Transform attack_dir in a Vec2
			_ranged_attack(attack_dir)

func _physics_process(delta: float) -> void:
	_move(delta)
	self.velocity.y += gravity * delta


func _move(delta: float) -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	self.velocity.x = direction * (SPEED * delta)
	
	# Controls the animation
	if (direction != 0 && !is_jumping && !is_attacking):
		_animation("walk")
		animation.flip_h = true if (direction < 0) else false
		spear_attack_area.position.x = -29.5 if (direction <0) else 29.5
	elif (is_jumping && !is_attacking):
		_animation("jump")
		animation.flip_h = true if (direction < 0) else false
		spear_attack_area.position.x = -29.5 if (direction <0) else 29.5
	elif (!is_attacking):
		_animation("idle")
	
	# Verifies jump
	_verify_jump()
	move_and_slide()


func _verify_jump() -> void:
	if (Input.is_action_pressed("jump") && is_on_floor()):
		self.velocity.y = -JUMP_STRENGH
		is_jumping = true
		
	elif (!is_on_floor()):
		is_jumping = true
	else:
		is_jumping = false
		


func take_damage(dmg: int) -> void:
		current_health -= dmg
		PlayerAttrib.set_health(current_health)
		
		self.modulate = Color(1,0,0)
		hit_timer.start()
		if (current_health <= 0):
			call_deferred("_die")


func _die() -> void:
	get_tree().change_scene_to_packed(daughter_scene)
	self.queue_free()

func _on_timer_timeout() -> void:
	self.modulate = Color(1,1,1)

func _animation(anim_name: String) -> void:
	animation.play(anim_name)


func _on_attack_box_body_entered(body):
	can_attack = false
	if (body.is_in_group("enemies")):
		body.take_damage(damage)


func _on_attack_timer_timeout():
	can_attack = true
	is_attacking = false
	spear_attack_area.disabled = true
	
func _rock_attack(dir) -> void:
	rock_attack_area.disabled = false
	is_attacking = true
	rock_attack_timer.start()
	
	animation.flip_h = true if (dir < 0) else false
	spear_attack_area.position.x = -29.5 if (dir <0) else 29.5
	_animation("attack")

func _spear_attack(dir) -> void:
	spear_attack_area.disabled = false
	is_attacking = true
	spear_attack_timer.start()
	
	animation.flip_h = true if (dir < 0) else false
	spear_attack_area.position.x = -29.5 if (dir <0) else 29.5
	_animation("attack")
	
func _ranged_attack(dir) -> void:
	var new_proj = preload("res://scenes/extras/projectiles/mother_projectile.tscn").instantiate()
	self.add_child(new_proj)
	
	new_proj.direction.x = dir
	new_proj.scale = Vector2(0.3, 0.3)
