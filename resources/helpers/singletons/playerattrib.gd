class_name PlayerAttributes
extends Node

# Draw Properties
@onready var position: Vector2
@onready var scale: Vector2
@onready var direction: int # X axis
@onready var dash_direction
@onready var attack_box: CollisionShape2D
@onready var animation: AnimatedSprite2D # Transform this into a state machine
@onready var character: String
@onready var purify_target
@onready var points = 0
# Health
@onready var current_life: int
@onready var max_health: int

# Damages
@onready var rock_dmg: int = 4
@onready var spear_dmg: int = 10
@onready var ranged_dmg: int = 7

# --- HEALTH ---
func get_health() -> int:
	return current_life

func set_health(health: int) -> void:
	current_life = health

func get_max_health() -> int:
	return max_health

func set_max_health(value: int) -> void:
	max_health = value