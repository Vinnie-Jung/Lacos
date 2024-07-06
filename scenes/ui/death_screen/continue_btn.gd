extends Node

@onready var current_scene: Node = Scenehandler.current_scene
@onready var mother_scene: PackedScene = preload("res://scenes/levels/level_1_0.tscn")
@onready var daughter_scene: PackedScene = preload("res://scenes/levels/level_1_1.tscn")

func continue_btn_pressed() -> void:
	get_player()

func get_player() -> void:
	var scene: PackedScene
	
	if (PlayerAttrib.character == "mother"):
		scene = daughter_scene
	elif (PlayerAttrib.character == "daughter"):
		scene = mother_scene
		
	get_tree().change_scene_to_packed(scene)
