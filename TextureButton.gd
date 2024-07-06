extends TextureButton
class_name SkillNode
@onready var panel = $Panel
@onready var label = $MarginContainer/Label
@onready var line = $Line2D

var skill_name
var price
func _ready():
	#price = int(label.text)
	skill_name = self.name
	label.text = skill_name + str(price)
	if (skill_name == "Rock"):
		panel.show_behind_parent = true
		self.disabled = false
		#self.button_pressed = true
	'''
	if get_parent() is SkillNode:
		line.add_point(global_position + size/2)
		line.add_point(get_parent().global_position + size/2)
	'''

func _on_pressed():
	if (skill_name == "Rock"):
		price = 0
	elif (skill_name == "Spear"):
		price = 3
	elif (skill_name == "Range"):
		price = 3
	elif (skill_name == "Dash"):
		price = 10
	else:
		price = 10000
		
	if (Soulhandler.get_soul_amount() >= price && !panel.show_behind_parent && skill_name != "Rock"):
		panel.show_behind_parent = true
		label.queue_free()
		#line.default_color = Color(1,1,0,1)
		Soulhandler.spend_soul(price)
		set_skill()
	
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode:
			skill.disabled = false

func set_skill():
	if skill_name == "Spear":
		Skillhandler.unlock_skill("spear_attack")
	elif skill_name == "Ranged":
		Skillhandler.unlock_skill("ranged_attack")
	elif skill_name == "Dash":
		Skillhandler.unlock_skill("dash")
	else:
		Skillhandler.unlock_skill("rock_attack")
		
	PlayerAttrib.points += 1
		
