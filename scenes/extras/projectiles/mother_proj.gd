class_name MotherProjectile
extends Area2D

@export var direction: Vector2 = Vector2.ZERO
@export var damage: int = 0

const PROJECTILE_SPEED: int = 1000

func _physics_process(delta: float) -> void:
	self.position += direction * (PROJECTILE_SPEED * delta)

func _on_body_entered(body) -> void:
	# When hit a wall
	if (body is TileMap):
		proj_destroy()

	# When hit an enemy
	elif (body.is_in_group("enemies")):
		body.take_damage(damage)
		proj_destroy()

func proj_destroy() -> void:
	# Destroy projectile
	self.queue_free()

func _on_screen_exited() -> void:
	proj_destroy()
