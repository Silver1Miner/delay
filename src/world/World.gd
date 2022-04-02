extends Node2D

onready var player = $Navigation2D/Player
onready var gui = $CanvasLayer/GUI

func _ready() -> void:
	if player.connect("hp_changed", gui, "_on_Player_hp_changed") != OK:
		push_error("failed connect hp bars")
	if player.connect("en_changed", gui, "_on_Player_en_changed") != OK:
		push_error("failed connect en bars")
	if player.connect("level_changed", gui, "_on_Player_level_changed") != OK:
		push_error("failed connect level display")
	player.emit_signal("hp_changed", player.hp, player.max_hp)
	player.emit_signal("en_changed", player.en, player.max_en)
