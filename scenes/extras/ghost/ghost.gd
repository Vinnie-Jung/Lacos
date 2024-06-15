extends Sprite2D

func _ready() -> void:
	_ghosting()

func set_property(texture_position, texture_scale):
	self.position = texture_position
	self.scale = texture_scale

func _ghosting() -> void:
	# (TODO) study more about it
	var tween_fade = get_tree().create_tween()
	
	tween_fade.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.75)
	await tween_fade.finished
	self.queue_free()
