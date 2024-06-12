class_name HUD
extends CanvasLayer

@onready var health_lb: Label = $'Info/PlayerHealth'
@onready var fps_lb: Label = $'Info/FPS'
@onready var souls_lb: Label = $'Info/SoulsCollected'

func _process(_delta: float) -> void:
	var current_health = str(PlayerAttrib.get_health())
	var max_health = str(PlayerAttrib.get_max_health())

	# Sets labels texts
	health_lb.text = "Vida: " + current_health + "/" + max_health
	souls_lb.text = "Almas: " + str(Soulhandler.get_current_run_souls())
	fps_lb.text = "FPS: " + str(Engine.get_frames_per_second())
