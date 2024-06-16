extends Area2D

@export var direction: Vector2 = Vector2.ZERO
@export var damage: int = 0

const PROJECTILE_SPEED: int = 500
var out_of_screen: bool = false

func _physics_process(delta: float) -> void:
	if (direction.x <0):
		direction.x = -1
	else:
		direction.x = 1
	
	self.position.x += direction.x * (PROJECTILE_SPEED * delta)


func _on_body_entered(body):
	# When hit player
	if (body.name == "Mother" || body.name == "Daughter"):
		body.take_damage(damage)
		self.queue_free()

func proj_destroy() -> void:
	# When is out of screen
	if (out_of_screen):
		self.queue_free()

func _on_screen_exited() -> void:
	out_of_screen = true
	proj_destroy()
