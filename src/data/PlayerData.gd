extends Node

var main_menu = preload("res://src/menu/MainMenu.tscn")
var world = preload("res://src/world/World.tscn")

var Database: Resource = preload("res://database/database.tres")

var music_db := 0.4
var sound_db := 0.2

var current_level = 1
var delta_time = 0.0

var player_downgrades := { #id: level,
	-1: 0, # AI
	0: 0, # Left Gun
	1: 0, # Right Gun
	2: 0, # Blaze Burn
	3: 0, # Bolt Beam
}

func _ready() -> void:
	pass

signal player_downgraded()
func downgrade(downgrade_id: int) -> void:
	if downgrade_id < 0: # coin
		print("downgrade AI")
	elif player_downgrades[downgrade_id] < Database.downgrades[downgrade_id]["max_level"]:
		player_downgrades[downgrade_id] += 1
	emit_signal("player_downgraded")

func fresh_restart() -> void:
	delta_time = 0.0
	current_level = 1
	player_downgrades = { #id: level,
	-1: 0, # AI
	0: 0, # Left Gun
	1: 0, # Right Gun
	2: 0, # Blaze Burn
	3: 0, # Bolt Beam
}
