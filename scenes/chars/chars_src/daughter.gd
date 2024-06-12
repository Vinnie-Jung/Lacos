extends CharacterBody2D

@onready var timer: Timer = $TakeDamageTimer
@onready var super_jump_timer: Timer = $SuperPulo
@onready var animation = $Texture

# World
var gravity = 1500#ProjectSettings.get_setting("physics/2d/default_gravity")

# Character Attributes
var max_health: int = 10
var current_health: int = max_health
const SPEED: int = 250
const JUMP_STRENGTH: int = 800
const SUPER_JUMP_MULTIPLIER: float = 3
const SUPER_JUMP_COOLDOWN: float = 1.0

var can_super_jump = true
var jump_force = 0
var is_jumping: bool = false

func _ready() -> void:
	PlayerAttrib.set_max_health(max_health)
	PlayerAttrib.set_health(current_health)

func _physics_process(delta: float) -> void:
	_move(delta)
	print(is_on_floor())
	self.velocity.y += gravity * delta

func _move(delta: float) -> void:
	var direction: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	self.velocity.x = direction * SPEED

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		jump_force = JUMP_STRENGTH
		
	# Controls the animation
	if (direction != 0 && is_on_floor()):
		_animation("float")
		animation.flip_h = true if (direction < 0) else false
	elif (is_jumping):
		_animation("super_jump")
		animation.flip_h = true if (direction < 0) else false
	else:
		_animation("idle")
		
	

	_verify_jump(delta)
	move_and_slide()

func _verify_jump(delta) -> void:
	if Input.is_action_pressed("jump") and is_on_floor():
		if can_super_jump:
			jump_force = min(jump_force + JUMP_STRENGTH * delta, JUMP_STRENGTH * SUPER_JUMP_MULTIPLIER)
			is_jumping = true
		else:
			jump_force = min(jump_force + JUMP_STRENGTH * delta, JUMP_STRENGTH)
	elif Input.is_action_just_released("jump") and is_on_floor():
		jump()
		jump_force = 0
		is_jumping = true
		
	if (!is_on_floor()):
		is_jumping = true
	else:
		is_jumping = false

func jump() -> void:
	if can_super_jump:
		self.velocity.y = -jump_force
		can_super_jump = false
		super_jump_timer.start()
	else:
		self.velocity.y = -jump_force

func _on_super_jump_timeout() -> void:
	can_super_jump = true

func take_damage(dmg: int) -> void:
	if (!get_child(-1).name == "shield"):
		current_health -= dmg
		PlayerAttrib.set_health(current_health)
		self.modulate = Color(1, 0, 0)
		timer.start()
		if current_health <= 0:
			call_deferred("_die")

func _die() -> void:
	var skill_tree = preload("res://control.tscn")
	get_tree().change_scene_to_packed(skill_tree)
	self.queue_free()

func _on_timer_timeout() -> void:
	self.modulate = Color(1, 1, 1)
	
	

func shield():
	var shild = ColorRect.new()
	
	
	self.add_child(shild)
	shild.custom_minimum_size = Vector2(100,100)
	shild.name = "shield"
	shild.position = Vector2(-55,0)
	
	shild.color = Color(0,0,1, 0)
	self.modulate = Color(0, 0, 1)
func destroy_shield(node):
	node.queue_free()


func _input(event):
	if event is InputEventKey:
		if (Input.is_key_pressed(KEY_Q)):
			shield()
			var shield = $Shield
			shield.start()


func _on_shield_timeout():
	destroy_shield(get_parent().get_child(-1))
	self.modulate = Color(1, 1, 1)

func _animation(anim_name: String) -> void:
	animation.play(anim_name)
