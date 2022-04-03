extends Node

var main_menu = preload("res://src/menu/MainMenu.tscn")
var world = preload("res://src/world/World.tscn")

var Database: Resource = preload("res://database/database.tres")

var music_db := 0.4
var sound_db := 0.2

var current_level = 1
var delta_time = 0.0
var longest_time = 0.0
var lore_collected = 0
var max_lore = 4
var ai_down = 0

var player_downgrades := { #id: level,
	-1: 0, # AI
	0: 0, # Left Gun
	1: 0, # Right Gun
	2: 0, # Blaze Burn
	3: 0, # Bolt Beam
	4: 0, # Energy Drain
}

func _ready() -> void:
	load_game()

signal player_downgraded()
func downgrade(downgrade_id: int) -> void:
	if downgrade_id < 0: # AI
		ai_down += 1
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
	4: 0, # Energy Drain
}

func load_game() -> void:
	var save_game = File.new()
	if not save_game.file_exists("user://blaze.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://blaze.save", File.READ)
	longest_time = parse_json(save_game.get_line())
	lore_collected = parse_json(save_game.get_line())
	music_db = parse_json(save_game.get_line())
	sound_db = parse_json(save_game.get_line())
	save_game.close()

func save_game() -> void:
	var save_game = File.new()
	save_game.open("user://blaze.save", File.WRITE)
	save_game.store_line(to_json(longest_time))
	save_game.store_line(to_json(lore_collected))
	save_game.store_line(to_json(music_db))
	save_game.store_line(to_json(sound_db))
	save_game.close()

func clear_game() -> void:
	longest_time = 0.0
	lore_collected = 0
	var dir = Directory.new()
	dir.remove("user://blaze.save")
