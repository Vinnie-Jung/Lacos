extends Area2D

@export var direction: Vector2 = Vector2.ZERO
@export var damage: int = 0

const PROJECTILE_SPEED: int = 1000
var out_of_screen: bool = false

func _physics_process(delta: float) -> void:
	if (direction == Vector2.ZERO):
		direction = Vector2(1,0)
	
	self.position += direction * (PROJECTILE_SPEED * delta)

func _on_body_entered(body):
	# When hit an enemy
	if (body.is_in_group("enemies")):
		body.take_damage(damage)
		self.queue_free()

func proj_destroy() -> void:
	# When is out of screen
	if (out_of_screen):
		self.queue_free()

func _on_screen_exited() -> void:
	out_of_screen = true
	proj_destroy()
