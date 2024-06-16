class_name MainMenuBtns
extends VBoxContainer

# Preloads
@onready var new_level: PackedScene = preload("res://scenes/levels/level_1_0.tscn")
@onready var confirm_quit_box: PackedScene = preload("res://scenes/menu/confirm_quit_box.tscn")

# Buttons
@onready var playBtn: Button = $PlayBtn
@onready var optionsBtn: Button = $OptionsBtn
@onready var quitBtn: Button = $QuitBtn

func _ready() -> void:
	var buttons: Array[Node] = _set_buttons()

	# Creates a signal to all buttons
	for button in buttons:
		button.pressed.connect(_button_pressed.bind(button))

func _set_buttons() -> Array[Node]:
	var button_list: Array[Node] = self.get_children()

	# Adds all buttons to the same group
	for button in button_list:
		button.add_to_group("main_menu_buttons")

	# Set disabled buttons
	optionsBtn.disabled = true
	optionsBtn.focus_mode = Control.FOCUS_NONE

	return button_list


func _button_pressed(button: Button) -> void:
	match button.name:
		"PlayBtn":
			get_tree().change_scene_to_packed(new_level)
		"OptionsBtn":
			pass
		"QuitBtn":
			_quit()


func _quit() -> void:
	var quit_box: CanvasLayer = confirm_quit_box.instantiate()
	get_tree().root.add_child(quit_box)
