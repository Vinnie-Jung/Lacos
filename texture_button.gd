extends TextureButton
@onready var panel = $Panel
@onready var label = $MarginContainer/Label
@onready var line = $Line2D

var skill_name
var price
func _ready():
	price = 1
	skill_name = self.name
	label.text = skill_name + str(price)
	if (skill_name == "SuperJump"):
		panel.show_behind_parent = true
		self.disabled = false
		self.button_pressed = true
	'''
	if get_parent() is SkillNode:
		line.add_point(global_position + size/2)
		line.add_point(get_parent().global_position + size/2)
	'''

func _on_pressed():
	if (PlayerAttrib.points >= price && !panel.show_behind_parent && skill_name != "SuperJump"):
		panel.show_behind_parent = true
		label.queue_free()
		#line.default_color = Color(1,1,0,1)
		PlayerAttrib.points -= price
		set_skill()
	
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode:
			skill.disabled = false

func set_skill():
	if skill_name == "Shield":
		Skillhandler.unlock_skill("shield")
	elif skill_name == "Purify":
		Skillhandler.unlock_skill("purify")
	elif skill_name == "Invisibility":
		Skillhandler.unlock_skill("invisibility")
		
