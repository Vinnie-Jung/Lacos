extends Control

# Nodes
@onready var life_bar: ProgressBar = $LifeBar
@onready var life_bar_timer: Timer = $LifeBarVisible

# Attribs
@onready var current_life = self.get_parent().current_health
@onready var max_health = self.get_parent().max_health

func _ready() -> void:
	# Setting bar values
	life_bar.max_value = max_health
	life_bar.value = current_life
	
	# Setting bar color
	life_bar.modulate = Color(0, 1, 0)

func _process(_delta) -> void:
	# Updating bar values
	current_life = self.get_parent().current_health
	life_bar.value = current_life
	_bar_behavior()
		
func _bar_behavior() -> void:
	# Hides bar when has full health
	if (life_bar.value == life_bar.max_value):
		life_bar.visible = false
	else:
		life_bar.visible = true
		
	# Maybe implement a hided bar after a few moments
