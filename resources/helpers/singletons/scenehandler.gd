class_name SceneHandler
extends Node

############################################
# (TODO) Create a better scene search
############################################

@export var current_scene: Node

@onready var aux: Node = Node.new()

func _process(_delta: float) -> void:
	current_scene = find_current_scene()

func find_current_scene() -> Node:
	var singleton_count: int = 0
	var singletons: DirAccess = DirAccess.open("res://config/")
	
	# Counts singletons in config folder
	for script in singletons.get_files():
		singleton_count += 1
		
	singletons = DirAccess.open("res://resources/helpers/singletons/")
	
	# Counts singletons in handlers folder
	for script in singletons.get_files():
		singleton_count += 1
		
	# Verifies if there is a scene
	if (get_tree().root.get_child_count() < singleton_count):
		singleton_count -= 1
		
	return get_tree().root.get_child(singleton_count)
