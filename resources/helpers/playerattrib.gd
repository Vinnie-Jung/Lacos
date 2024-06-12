class_name PlayerAttributes
extends Node

@onready var current_life: int
@onready var max_health: int

func get_health() -> int:
    return current_life

func set_health(health: int) -> void:
    current_life = health

func get_max_health() -> int:
    return max_health

func set_max_health(value: int) -> void:
    max_health = value