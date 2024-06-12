class_name ConfirmQuitBox
extends HBoxContainer

func _ready() -> void:
	var button_list: Array[Node] = self.get_children()

	# Creating a signal for buttons
	for button in button_list:
		button.pressed.connect(_button_pressed.bind(button))


func _button_pressed(button: Button) -> void:
	match button.name:
		"DenyBtn":
			var nodes_in_tree = get_tree().root.get_child_count()
			var quit_box: CanvasLayer = get_tree().root.get_child(nodes_in_tree - 1) # main node (ConfirmQuitBox)
			quit_box.queue_free()
		"ConfirmBtn":
			get_tree().quit()
