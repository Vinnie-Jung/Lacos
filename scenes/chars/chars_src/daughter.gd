extends CharacterBody2D

@export var is_inv: bool = false

@onready var timer: Timer = $TakeDamageTimer
@onready var super_jump_timer: Timer = $SuperJump
@onready var animation = $Texture
@onready var collision_box = $Collision
@onready var invisibility_cooldown = $InvisibilityCooldown
@onready var invisibility_timer = $InvisibilityDuration
@onready var shield_cooldown = $ShieldCooldown
@onready var shield_duration = $ShieldDuration

var can_shield = true
var can_use_skill = true

# World
var gravity = 1200

# Character Attributes
var max_health: int = 10
var current_health: int = max_health
const SPEED: int = 25000
const JUMP_STRENGTH: int = 700

var can_super_jump = true
var jump_force = 0
var is_jumping: bool = false

var can_hide = true

func _ready() -> void:
	PlayerAttrib.set_max_health(max_health)
	PlayerAttrib.set_health(current_health)

func _physics_process(delta: float) -> void:
	_move(delta)
	self.velocity.y += gravity * delta

func _move(delta: float) -> void:
	var direction: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	self.velocity.x = direction * SPEED * delta

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
		
	_verify_jump()
	move_and_slide()

func _verify_jump() -> void:
	if (Input.is_action_pressed("jump") && is_on_floor()):
		self.velocity.y = -JUMP_STRENGTH
		is_jumping = true
		
	elif (Input.is_action_pressed("super_jump") && is_on_floor()):
		self.velocity.y = -JUMP_STRENGTH * 1.5
		is_jumping = true
		
	elif (!is_on_floor()):
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
	var aux
	for child in self.get_children():
		if (child.name == "ShieldGenerated"):
			aux = child
	if (aux == null):
		current_health -= dmg
		PlayerAttrib.set_health(current_health)
		self.modulate = Color(1, 0, 0)
		timer.start()
		if current_health <= 0:
			call_deferred("_die")

func _die() -> void:
	Soulhandler.reset_soul_counter()
	var skill_tree = load("res://scenes/menu/main_menu.tscn")
	get_tree().change_scene_to_packed(skill_tree)
	self.queue_free()

func _on_timer_timeout() -> void:
	self.modulate = Color(1, 1, 1)
	

func shield_skill():
	var shild = ColorRect.new()
	self.add_child(shild)
	shild.custom_minimum_size = Vector2(100,100)
	shild.name = "ShieldGenerated"
	shild.position = Vector2(-55,0)
	
	shild.color = Color(0,0,1, 0)
	self.modulate = Color(0, 0, 1)
func destroy_shield(node):
	node.queue_free()


func _input(event):
	if event is InputEventKey:
		if (Input.is_key_pressed(KEY_Q) && can_shield && can_use_skill):
			can_use_skill = false
			shield_skill()
			shield_duration.start()
			
		if (event.is_action_pressed("invisibility") && can_hide && can_use_skill):
			can_use_skill = false
			invisibility()
			invisibility_timer.start()

# Duration
func _on_shield_timeout():
	can_shield = false
	for child in self.get_children():
		if (child.name == "ShieldGenerated"):
			destroy_shield(child)
	self.modulate = Color(1, 1, 1)
	shield_cooldown.start()
	can_use_skill = true

func _animation(anim_name: String) -> void:
	animation.play(anim_name)
	
	# Adjust float animation position
	if (anim_name == "float"):
		animation.position.y = -3
	else:
		animation.position.y = 0


func invisibility():
	is_inv = true
	can_hide = false
	self.modulate = Color(1, 1, 1, 0.4)


func _on_invisibility_duration_timeout():
	is_inv = false
	self.modulate = Color(1, 1, 1, 1)
	invisibility_cooldown.start()
	can_use_skill = true


func _on_invisibility_cooldown_timeout():
	can_hide = true


func _on_shield_cooldown_timeout():
	can_shield = true
