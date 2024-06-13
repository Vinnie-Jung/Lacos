class_name PlayerAttributes
extends Node

@onready var current_life: int
@onready var max_health: int
@onready var base_attack_damage: int
@onready var attack_multiplyer: int = 1

func get_health() -> int:
	return current_life

func set_health(health: int) -> void:
	current_life = health

func get_max_health() -> int:
	return max_health

func set_max_health(value: int) -> void:
	max_health = value
