extends Button

func _on_pressed():
	if (PlayerAttrib.character == "mother"):
		var scene = preload("res://control.tscn")
		get_tree().change_scene_to_packed(scene)
	else:
		var scene = preload("res://scenes/ui/death_screen/control1.tscn")
		get_tree().change_scene_to_packed(scene)
