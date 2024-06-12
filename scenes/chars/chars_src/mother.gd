class_name Mother
extends CharacterBody2D

# Nodes
@onready var timer: Timer = $TakeDamageTimer
@onready var animation: AnimatedSprite2D = $Texture

# Preloads
@onready var daughter_scene: PackedScene = preload("res://scenes/levels/daugher_scene_prot.tscn")

# World
@onready var gravity = 1200#ProjectSettings.get_setting("physics/2d/default_gravity")

# Character Attributes
@onready var max_health: int = 10
@onready var current_health: int = max_health
const SPEED: int = 25000
const JUMP_STRENGH: int = 700
var is_jumping: bool

func _ready() -> void:
	# Sets handler
	PlayerAttrib.set_max_health(max_health)
	PlayerAttrib.set_health(current_health)
	
	# Sets initial animation
	_animation("idle")
	
	is_jumping = false



func _physics_process(delta: float) -> void:
	_move(delta)
	print(is_jumping)
	self.velocity.y += gravity * delta


func _move(delta: float) -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	self.velocity.x = direction * (SPEED * delta)
	
	# Controls the animation
	if (direction != 0 && !is_jumping):
		_animation("walk")
		animation.flip_h = true if (direction < 0) else false
	elif (is_jumping):
		_animation("jump")
		animation.flip_h = true if (direction < 0) else false
	else:
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
		timer.start()
		if (current_health <= 0):
			call_deferred("_die")


func _die() -> void:
	get_tree().change_scene_to_packed(daughter_scene)
	self.queue_free()

func _on_timer_timeout() -> void:
	self.modulate = Color(1,1,1)

func _animation(anim_name: String) -> void:
	animation.play(anim_name)
