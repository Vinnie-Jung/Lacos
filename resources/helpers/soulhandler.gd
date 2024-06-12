class_name SoulHandler
extends Node

# Preloads
@onready var soul: PackedScene = preload("res://scenes/collectables/soul.tscn")

# Souls collected
@onready var souls_collected_in_run: int = 0
@onready var total_souls_collected: int = 5

# --- IN RUN ---
func reset_soul_counter() -> void:
	souls_collected_in_run = 0

func add_soul(amount: int) -> void:
	souls_collected_in_run += amount
	total_souls_collected += souls_collected_in_run

func get_current_run_souls() -> int:
	return souls_collected_in_run

# --- STORE ---
func get_soul_amount() -> int:
	return total_souls_collected

func spend_soul(amount: int) -> void:
	total_souls_collected -= amount

# -- Enemies ---
func drop_soul(character: CharacterBody2D, amount: int) -> void:
	# Drops the referenced amount of souls
	for i in amount:
		var new_soul = soul.instantiate()
		var parent = character.get_parent()
		new_soul.position = character.position
		parent.add_child(new_soul)

