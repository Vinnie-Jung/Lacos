extends CharacterBody2D

# Publics
@export var is_inv: bool = false
@export var can_use_skill: bool = true
@export var can_shield: bool = true
@export var can_hide: bool = true

# Cooldowns
@onready var hit_cooldown: Timer = $HitCooldown

# Nodes
@onready var animation: AnimatedSprite2D = $Texture
@onready var collision_box: CollisionShape2D = $Collision

# Bools
var is_jumping: bool = false
var is_falling: bool = false

# World
var gravity: int = 1200
var jump_force = 0

# Character Attributes
var max_health: int = 10
var current_health: int = max_health
const SPEED: int = 25000
const JUMP_STRENGTH: int = 700

func _ready() -> void:
	# Sets Player attributes
	PlayerAttrib.set_max_health(max_health)
	PlayerAttrib.set_health(current_health)

	# Sets group
	self.add_to_group("player")
	self.add_to_group("daughter")
	
	# Changes node name
	self.name = "Player"

func _physics_process(delta: float) -> void:
	move(delta)
	
	# Gravity
	self.velocity.y += gravity * delta

func move(delta: float) -> void:
	var direction: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	self.velocity.x = direction * SPEED * delta
		
	# Controls the animation
	if (direction != 0 && is_on_floor()):
		_animation("float")
		animation.flip_h = true if (direction < 0) else false
	elif (is_jumping):
		_animation("super_jump")
		animation.flip_h = true if (direction < 0) else false
	elif (is_falling):
		_animation("falling")
		animation.flip_h = true if (direction < 0) else false
	else:
		_animation("idle")
		
	_verify_jump()
	move_and_slide()
	
	PlayerAttrib.position = self.position

func _verify_jump() -> void:
	if (Input.is_action_pressed("jump") && is_on_floor()):
		self.velocity.y = -JUMP_STRENGTH
		is_jumping = true
		
	elif (Input.is_action_pressed("super_jump") && is_on_floor()):
		self.velocity.y = -JUMP_STRENGTH * 1.5
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
	var aux
	for child in self.get_children():
		if (child.name == "ShieldGenerated"):
			aux = child
			
	# If there is no shield...
	if (aux == null):
		current_health -= dmg
		PlayerAttrib.set_health(current_health)
		self.modulate = Color(1, 0, 0) # changes sprite to red
		hit_cooldown.start()
		if current_health <= 0:
			call_deferred("die")

func die() -> void:
	Soulhandler.reset_soul_counter()
	var skill_tree = load("res://scenes/menu/main_menu.tscn")
	get_tree().change_scene_to_packed(skill_tree)
	self.queue_free()
	
func _animation(anim_name: String) -> void:
	animation.play(anim_name)
	
	# Adjust float animation position
	if (anim_name == "float"):
		animation.position.y = -3
	else:
		animation.position.y = 0
	
# Hit cooldown
func _on_timer_timeout() -> void:
	self.modulate = Color(1, 1, 1)

