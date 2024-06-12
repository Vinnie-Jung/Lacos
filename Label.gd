extends Label

@onready var mother_scene = load("res://scenes/levels/mother_scene_prot.tscn")
@onready var menu_scene = load("res://scenes/menu/main_menu.tscn")
func _process(_delta):
	self.text = "Almas coletadas: " + str(Soulhandler.get_soul_amount())


func _on_button_pressed():
	get_tree().change_scene_to_packed(mother_scene)


func _on_button_2_pressed():
	get_tree().change_scene_to_packed(menu_scene)
