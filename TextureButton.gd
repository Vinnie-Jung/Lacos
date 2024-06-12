extends TextureButton
class_name SkillNode
@onready var panel = $Panel
@onready var label = $MarginContainer/Label
@onready var line = $Line2D

var price
func _ready():
	price = int(label.text)
	if get_parent() is SkillNode:
		line.add_point(global_position + size/2)
		line.add_point(get_parent().global_position + size/2)

func _on_pressed():
	if (Soulhandler.get_soul_amount() >= price && !panel.show_behind_parent):
		panel.show_behind_parent = true
		label.queue_free()
		line.default_color = Color(1,1,0,1)
		Soulhandler.spend_soul(price)
		
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode:
			skill.disabled = false
