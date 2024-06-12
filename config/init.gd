class_name Init
extends Node

@onready var viewport: Window = get_tree().root
@onready var config: GlobalConfig = GlobalConfig

func _ready() -> void:
	# Setting initial window behaviour
	_set_window_initial_values()
	_set_default_keymap()
	

func _set_window_initial_values() -> void:
	var video_settings: Dictionary = config.load_video_settings()

	# Window configured by config file (script: config.gd)
	DisplayServer.window_set_title(video_settings.window_title)
	DisplayServer.window_set_size(video_settings.resolution)
	DisplayServer.window_set_mode(video_settings.window_mode)

	# Window can be resized or not
	viewport.unresizable = !video_settings.resizable

	# Sets game scale mode
	viewport.content_scale_stretch = video_settings.stretch_mode

	# Window on screen center
	var screen_center: Vector2i = DisplayServer.screen_get_size() / 2
	var window_center: Vector2i = video_settings.resolution / 2

	viewport.position = screen_center - window_center


func _set_default_keymap() -> void:
	var key_list: Dictionary = config.load_keymap()

	# Adds all keybindings defined in config.gd
	# (Var action in this case will be the name of the action in settings.ini)
	for action in key_list:
		InputMap.add_action(action) # Adds an action (String)
		InputMap.action_add_event(action, key_list[action]) # Then adds a keycode for it


func _set_audio_scale_values() -> void:
	#var audio_settings: Dictionary = config.load_audio_settings()
	pass
