extends Node

@onready var viewport : Window = get_tree().root # scene's root
@onready var config : ConfigFile = ConfigFile.new()

# This file will be generated in user/Appdata/Roaming/Godot/app_userdata/GameFolder
# (Windows) | (Linux) -> home/.local/share/godot/app_userdata/GameFolder
const SETTING_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	# If file doesn't exists, create it.
	if (!FileAccess.file_exists(SETTING_FILE_PATH)):
		default_config()
		config.save(SETTING_FILE_PATH)
	else:
		# If file exists, just load it.
		config.load(SETTING_FILE_PATH)


func default_config() -> void:
	# --- Keymap ---
	config.set_value("keybinding", "move_left", "A")
	config.set_value("keybinding", "move_right", "D")
	config.set_value("keybinding", "jump", "W")
	config.set_value("keybinding", "melee_attack", "mouse_1")
	config.set_value("keybinding", "ranged_attack", "mouse_2")
	config.set_value("keybinding", "skill", "Q")
	config.set_value("keybinding", "dash", "F")

	# --- Video ---
	config.set_value("video", "fullscreen", false)
	config.set_value("video", "resizable", true)
	config.set_value("video", "resolution", DisplayServer.screen_get_size() / 1.5)
	config.set_value("video", "stretch_mode", viewport.CONTENT_SCALE_MODE_VIEWPORT)
	config.set_value("video", "window_title", ProjectSettings.get_setting("application/config/name"))
	config.set_value("video", "window_mode", DisplayServer.WINDOW_MODE_WINDOWED)

	# --- Audio ---
	config.set_value("audio", "master_volume", 0)
	config.set_value("audio", "sfx_volume", 0)


# ---------------  KEYMAP  ---------------
func save_keymap(action: String, event: InputEvent) -> void:
	var event_string: String

	if event is InputEventKey:
		event_string = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_string = "mouse_" + str(event.button_index)

	# There is no else, so be careful using this method

	config.set_value("keybinding", action, event_string)
	config.save(SETTING_FILE_PATH)


func load_keymap() -> Dictionary:
	var keybindings: Dictionary = {}
	var keys: PackedStringArray = config.get_section_keys("keybinding")

	# For current position in keybinding section
	for key in keys:
		var input_event
		var key_value = config.get_value("keybinding", key)

		if (key_value.contains("mouse_")):
			input_event = InputEventMouseButton.new()

			# Receives mouse button number splitting the value after underscore
			input_event.button_index = int(key_value.split("_")[1])
		else:
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(key_value)
		
		keybindings[key] = input_event

	return keybindings


# ---------------  VIDEO  ---------------
func save_video_settings(key: String, value) -> void:
	config.set_value("video", key, value)
	config.save(SETTING_FILE_PATH)


func load_video_settings() -> Dictionary:
	var video_settings: Dictionary = {}

	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)

	return video_settings


# ---------------  AUDIO  ---------------
func save_audio_settings(key: String, value) -> void:
	config.set_value("audio", key, value)
	config.save(SETTING_FILE_PATH)


func load_audio_settings() -> Dictionary:
	var audio_settings: Dictionary = {}

	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)

	return audio_settings
