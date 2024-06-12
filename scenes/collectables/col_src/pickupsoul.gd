class_name PickUpSoul
extends Sprite2D

func _on_pick_area_body_entered(body):
	if (body.name == "Mother" || body.name == "Daughter"):
		Soulhandler.add_soul(1)
		self.queue_free()
