class_name Enemy1
extends CharacterBody2D

# Nodes
@onready var attack_area = $Attack/Area
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var hit_timer: Timer = $HitTimer

# World
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Monster attributes
const SPEED: int = 10000
const JUMP_STRENGH: int = -1000
const ATTACK_DAMAGE: int = 2
const SOUL_DROP: int = 1
const MAX_HEALTH: int = 10
@export var current_health: int = MAX_HEALTH
@export var max_health: int = MAX_HEALTH
@onready var target = null

var can_attack = true
var in_range = false

@onready var animation = $Texture

func _ready() -> void:
	attack_cooldown.wait_time = 1.0
	attack_cooldown.one_shot = true
	_animation("walk")
	
func _physics_process(delta: float) -> void:
	_movement(delta)
	
	# Gravity
	self.velocity.y += gravity * delta if (!is_on_floor()) else 0
	

func _movement(delta: float) -> void:
	if (target is CharacterBody2D):
		var dir = (target.global_position - self.global_position).normalized()
		self.velocity.x = (SPEED * delta) * dir.x
		move_and_slide()
		
		if (dir.x < 0):
			attack_area.position.x = -32
			animation.flip_h = true
		else:
			attack_area.position.x = 32
			animation.flip_h = false
	else:
		pass

func take_damage(dmg: int) -> void:
	current_health -= dmg
	self.modulate = Color(1, 0, 0)
	hit_timer.start()
	
	if (current_health <= 0):
		call_deferred("_die")

func _die() -> void:
	Soulhandler.drop_soul(self, SOUL_DROP)
	self.queue_free()


func _on_radar_body_entered(body) -> void:
	if (body.name == "Mother" || body.name == "Daughter"):
		target = body

func _on_radar_body_exited(body) -> void:
	if (body.name == "Mother" || body.name == "Daughter"):
		target = null

func _on_attack_body_entered(body) -> void:
	in_range = true
	if (body.name == target.name && attack_cooldown.time_left == 0 && in_range):
		body.take_damage(ATTACK_DAMAGE)
		attack_cooldown.start()

func _animation(anim: String) -> void:
	animation.play(anim)


func _on_hit_timer_timeout():
	self.modulate = Color(1, 1, 1)


func _on_attack_cooldown_timeout():
	can_attack = true
	if (target != null && in_range):
		_on_attack_body_entered(target)


func _on_attack_body_exited(body):
	in_range = false
