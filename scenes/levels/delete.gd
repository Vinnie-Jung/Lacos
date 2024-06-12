extends Area2D

func _on_body_entered(body):
	body.call_deferred("_die")
