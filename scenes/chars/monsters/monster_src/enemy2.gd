extends CharacterBody2D
@onready var hit_timer: Timer = $HitTimer

const SOUL_DROP: int = 1
const DAMAGE: int = 10
const MAX_HEALTH: int = 25
const SPEED = 10000
@onready var current_health: int = MAX_HEALTH

var mouse_inside: bool = false
var complement = ""
@onready var test = $MouseArea/CollisionShape2D
var is_purifyed = false

@onready var attack_range = $Range
@onready var attack_cooldown = $AttackCooldown
@onready var animation = $Texture
@onready var terrain_left = $LeftTerrainDetector
@onready var terrain_right = $RightTerrainDetector

@export var max_health = MAX_HEALTH

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var target = null
var can_attack = true
var bodies_in_radar
var not_in_range = true

func _ready():
	animation.play("idle")

	# Sets group
	self.add_to_group("enemies")

func _physics_process(delta) -> void:
	if (!is_purifyed):
		bodies_in_radar = attack_range.get_overlapping_bodies()
		for body in bodies_in_radar:
			if (body is CharacterBody2D && body == target && can_attack):
				if (body.is_in_group("mother") || body.is_in_group("daughter") && !body.is_inv):
					can_attack = false
					attack()
					attack_cooldown.start()
		
		if (target != null):
			var dir = (target.global_position - self.global_position)
			if (terrain_left.is_colliding()):
				if (dir.x < 0):
					_movement(delta)
			if (terrain_right.is_colliding()):
				if (dir.x > 0):
					_movement(delta)
	else:
		setting_anim()
		animation.play("idle" + complement)
		target = null
				
	# Gravity
	self.velocity.y += gravity * delta if (!is_on_floor()) else 0

func _movement(delta: float) -> void:
	if (target is CharacterBody2D && not_in_range):
		var dir = (target.global_position - self.global_position).normalized()
		self.velocity.x = (SPEED * delta) * dir.x
		move_and_slide()
		
		if (dir.x < 0):
			animation.flip_h = true
		else:
			animation.flip_h = false

func take_damage(dmg: int) -> void:
	current_health -= dmg
	self.modulate = Color(1, 0, 0)
	hit_timer.start()
	
	if (current_health <= 0):
		call_deferred("_die")

func _die() -> void:
	Soulhandler.drop_soul(self, SOUL_DROP)
	self.queue_free()


func _on_hit_timer_timeout():
	self.modulate = Color(1,1,1)


func _on_radar_body_entered(body) -> void:
	if (body.is_in_group("player")):
		target = body
		
		if (body.name == "Daughter" && body.is_inv):
			target = null

func _on_radar_body_exited(body) -> void:
	if (body.is_in_group("player")):
		target = null

func attack() -> void:
	var dir = self.global_position - target.global_position
	var new_proj = preload("res://scenes/extras/projectiles/enemy_projectile.tscn").instantiate()
	
	get_parent().add_child(new_proj)
	
	new_proj.position = self.position
	new_proj.direction = -dir
	new_proj.scale = Vector2(0.3, 0.3)
	new_proj.damage = DAMAGE

func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func _on_range_body_entered(_body) -> void:
	not_in_range = false

func _on_range_body_exited(_body) -> void:
	not_in_range = true

func setting_anim():
	if (is_purifyed):
			complement = "_purify"
			animation.play("idle" + complement)

func _on_mouse_area_mouse_entered():
	mouse_inside = true


func _on_mouse_area_mouse_exited():
	mouse_inside = false

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("purify_skill") && Skillhandler.can_purify && Skillhandler.purify_unlocked:
			if (mouse_inside):
				is_purifyed = true
