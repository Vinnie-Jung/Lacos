class_name Enemy2Projectile
extends Area2D

@export var direction: Vector2 = Vector2.ZERO
@export var damage: int = 0

const PROJECTILE_SPEED: int = 500

func _physics_process(delta: float) -> void:
	if (direction.x <0):
		direction.x = -1
	else:
		direction.x = 1
	
	self.position.x += direction.x * (PROJECTILE_SPEED * delta)

func _on_body_entered(body):
	# When hit player
	if (body.is_in_group("player")):
		body.take_damage(damage)
		proj_destroy()

func proj_destroy() -> void:
	# Destroy projectile
	self.queue_free()

func _on_screen_exited() -> void:
	proj_destroy()
