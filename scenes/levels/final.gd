extends Area2D

@onready var mother_level = load("res://scenes/levels/level_1_0.tscn")
@onready var daughter_level = load("res://scenes/levels/level_1_1.tscn")
@onready var menu_scene = load("res://scenes/menu/main_menu.tscn")

func _on_body_entered(body) -> void:
	if (body.is_in_group("mother")):
		get_tree().call_deferred("change_scene_to_packed", daughter_level)
		#get_tree().change_scene_to_packed(daughter_level)
	elif (body.is_in_group("daughter")):
		get_tree().call_deferred("change_scene_to_packed", mother_level)
		#get_tree().change_scene_to_packed(menu_scene)
