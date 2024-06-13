extends Area2D

@export var direction: Vector2 = Vector2.ZERO

const PROJECTILE_SPEED: int = 1000

func _physics_process(delta: float) -> void:
	if (direction == Vector2.ZERO):
		direction = Vector2(1,0)
	
	self.position += direction * (PROJECTILE_SPEED * delta)
