class_name Enemy1
extends CharacterBody2D

# Nodes
@onready var attack_area = $Attack/Area
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var hit_timer: Timer = $HitTimer
@onready var terrain_left = $LeftTerrainDetector
@onready var terrain_right = $RightTerrainDetector
@onready var radar = $Radar
@onready var collision = $Collision
@onready var animation = $Texture

var mouse_inside: bool = false
var complement = ""

# World
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Monster attributes
@export var current_health: int = MAX_HEALTH
@export var max_health: int = MAX_HEALTH
@onready var target = null
@onready var can_attack = true
@onready var in_range = false
const SPEED: int = 10000
const ATTACK_DAMAGE: int = 5
const SOUL_DROP: int = 1
const MAX_HEALTH: int = 20
@onready var test = $MouseArea/CollisionShape2D
var is_purifyed = false

func _ready() -> void:
	attack_cooldown.wait_time = 1.5
	attack_cooldown.one_shot = true
	_animation("walk" + complement)

	# Sets group
	self.add_to_group("enemies")
	
func _physics_process(delta: float) -> void:
	if (!is_purifyed):
		if (terrain_left.is_colliding() && terrain_right.is_colliding()):
			_movement(delta)
		elif (target != null):
			var dir = (target.global_position - self.global_position)
			if (terrain_left.is_colliding()):
				if (dir.x < 0):
					_movement(delta)
			if (terrain_right.is_colliding()):
				if (dir.x > 0):
					_movement(delta)
		
		var bodies_in_radar = radar.get_overlapping_bodies()
		
		for body in bodies_in_radar:
			if (body.is_in_group("daughter") && !Skillhandler.is_inv):
				target = body
				
			if (body.is_in_group("daughter") && Skillhandler.is_inv):
				target = null
	else:
		setting_anim()
		_animation("walk" + complement)
		target = null
	
	# Gravity
	self.velocity.y += gravity * delta if (!is_on_floor()) else 0
	

func _movement(delta: float) -> void:
	if (target is CharacterBody2D && !in_range):
		var dir = (target.global_position - self.global_position).normalized()
		self.velocity.x = (SPEED * delta) * dir.x
		move_and_slide()
		
		# Positioning attack area
		if (dir.x < 0):
			attack_area.position.x = -32
			animation.flip_h = true
		else:
			attack_area.position.x = 32
			animation.flip_h = false

func take_damage(dmg: int) -> void:
	current_health -= dmg
	self.modulate = Color(1, 0, 0)
	hit_timer.start()

	if (current_health <= 0):
		call_deferred("die")

func die() -> void:
	Soulhandler.drop_soul(self, SOUL_DROP)
	self.queue_free()

func _animation(anim: String) -> void:
	animation.play(anim)

# ========== SIGNALS ==========
func _on_radar_body_entered(body) -> void:
	if (body.is_in_group("player") && !is_purifyed):
		target = body
		
		if (body.is_in_group("daughter") && Skillhandler.is_inv):
			target = null

func _on_radar_body_exited(body) -> void:
	if (body.is_in_group("player")):
		target = null

func _on_attack_body_entered(body) -> void:
	in_range = true
	if (target != null):
		if (body.name == target.name && attack_cooldown.time_left == 0 && in_range):
			body.take_damage(ATTACK_DAMAGE)
			attack_cooldown.start()

func _on_hit_timer_timeout():
	self.modulate = Color(1, 1, 1)

func _on_attack_cooldown_timeout():
	can_attack = true
	if (target != null && in_range):
		_on_attack_body_entered(target)

func _on_attack_body_exited(body):
	if (body.is_in_group("player")):
		in_range = false

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("purify_skill") && Skillhandler.can_purify && Skillhandler.purify_unlocked:
			if (mouse_inside):
				is_purifyed = true
			
			
				#var id = self.get_index()

func setting_anim():
	if (is_purifyed):
			complement = "_purify"
			self._animation("walk" + complement)





func _on_mouse_area_mouse_entered():
	mouse_inside = true


func _on_mouse_area_mouse_exited():
	mouse_inside = false
