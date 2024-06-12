extends CharacterBody2D

# Nodes
@onready var bulletScene = preload("res://scenes/extras/bullet.tscn") # Seu scene de bala
@onready var timer: Timer = $AttackTimer

# World
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Monster attributes
const SPEED: int = 100
const ATTACK_DAMAGE: int = 2
const SOUL_DROP: int = 1
const MAX_HEALTH: int = 10
@onready var current_health: int = MAX_HEALTH
@onready var target = null

func _ready() -> void:
	timer.wait_time = 2.0
	timer.one_shot = false
	timer.start()

func _physics_process(delta: float) -> void:
	_movement(delta)
	
	# Gravity
	self.velocity.y += gravity * delta if (!is_on_floor()) else 0
	
func _movement(delta: float) -> void:
	if (target is CharacterBody2D):
		var dir = (target.global_position - self.global_position).normalized()
		self.velocity.x = (SPEED * delta) * dir.x
	else:
		self.velocity.x = 0

	move_and_slide()

func take_damage(dmg: int) -> void:
	current_health -= dmg    
	if (current_health <= 0):
		_die()

func _die() -> void:
	Soulhandler.drop_soul(self, SOUL_DROP)
	self.queue_free()

func _on_Timer_timeout() -> void:
	if (target != null):
		_shoot()

func _shoot() -> void:
	if ($BulletPosition.is_in_group("bullet_ready")):
		print("bulletttt")
		var bullet = bulletScene.instance()
		bullet.global_position = $BulletPosition.global_position
		bullet.rotation_degrees = $BulletPosition.global_rotation_degrees
		bullet.set_direction(target.global_position - bullet.global_position)
		get_parent().add_child(bullet)
		bullet.connect("body_entered", self, "_on_Bullet_body_entered")
		bullet.start()
		$BulletPosition.remove_from_group("bullet_ready")

func _on_Bullet_body_entered(body) -> void:
	if (body.name == target.name):
		body.take_damage(ATTACK_DAMAGE)
