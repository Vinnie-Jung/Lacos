extends Node


@onready var main_menu_scene: PackedScene = load("res://scenes/menu/main_menu.tscn")

func menu_btn_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
