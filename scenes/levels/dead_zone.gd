extends Area2D

func _on_body_entered(body: CharacterBody2D) -> void:
	body.call_deferred("_die")
