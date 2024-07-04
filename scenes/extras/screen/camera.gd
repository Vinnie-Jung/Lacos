class_name LevelCamera
extends Camera2D

# Scene Nodes
@onready var parent: Node = self.get_parent()
@onready var player: CharacterBody2D

# Camera Limits
@onready var left_limit: int 
@onready var right_limit: int
@onready var bottom_limit: int
@onready var top_limit: int

func _ready() -> void:
	find_edges()
	find_player()
		
	self.limit_left = left_limit
	self.limit_right = right_limit
	self.limit_bottom = bottom_limit
	self.limit_top = top_limit
	self.limit_smoothed = true
	
func _process(_delta: float) -> void:
	follow_player()
	
func find_edges() -> void:
	# Horizontal axis
	if (parent.find_child("LeftCamEdge")):
		left_limit = parent.find_child("LeftCamEdge").position.x
	if (parent.find_child("LeftCamEdge")):
		right_limit = parent.find_child("RightCamEdge").position.x
		
	# Vertical axis
	if (parent.find_child("BottomCamEdge")):
		bottom_limit = parent.find_child("BottomCamEdge").position.y
	if (parent.find_child("TopCamEdge")):
		top_limit = parent.find_child("TopCamEdge").position.y

func find_player() -> void:
	if (parent.find_child("Player")):
		player = parent.find_child("Player")
		
func follow_player() -> void:
	# Cam Center Anchor
	self.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	self.position = player.position
