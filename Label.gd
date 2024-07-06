extends Label

@onready var mother_scene = load("res://scenes/levels/level_1_0.tscn")
@onready var daughter_scene = load("res://scenes/levels/level_1_1.tscn")
@onready var menu_scene = load("res://scenes/menu/main_menu.tscn")
func _process(_delta):
	if (self.get_parent().name == "Control"):
		self.text = "Almas coletadas: " + str(Soulhandler.get_soul_amount())
	elif (self.get_parent().name == "Control1"):
		self.text = "Pontos disponíveis: " + str(PlayerAttrib.points)


func _on_button_pressed():
	if (PlayerAttrib.character == "mother"):
		get_tree().change_scene_to_packed(daughter_scene)
	else:
		get_tree().change_scene_to_packed(mother_scene)


func _on_button_2_pressed():
	get_tree().change_scene_to_packed(menu_scene)
