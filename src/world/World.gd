extends Node2D

onready var player = $Navigation2D/Player
onready var gui = $CanvasLayer/GUI
onready var SpawnPoints = $Navigation2D/SpawnPoints
onready var GUIDisplay = $CanvasLayer/GUI
onready var EnemySpawn = $Navigation2D/EnemySpawner
var Database: Resource = preload("res://database/database.tres")

func _ready() -> void:
	if player.connect("hp_changed", gui, "_on_Player_hp_changed") != OK:
		push_error("failed connect hp bars")
	if player.connect("en_changed", gui, "_on_Player_en_changed") != OK:
		push_error("failed connect en bars")
	if player.connect("level_changed", gui, "_on_Player_level_changed") != OK:
		push_error("failed connect level display")
	player.emit_signal("hp_changed", player.hp, player.max_hp)
	player.emit_signal("en_changed", player.en, player.max_en)
	PlayerData.delta_time = 0.0

var timer_accumulated = 0
var spawn_accumulated = 0
var spawn_timer = 300
var spawn_level = 0
func _process(delta: float) -> void:
	PlayerData.delta_time += delta
	spawn_accumulated += 1
	timer_accumulated += 1
	if timer_accumulated >= 60:
		GUIDisplay.update_clock(PlayerData.delta_time)
		timer_accumulated = 0
	if spawn_accumulated >= Database.spawn_schedule["spawn_pace"][spawn_level]:
		spawner()

func spawner() -> void:
	if SpawnPoints.get_children().size() > 0 and \
	EnemySpawn.get_children().size() <= Database.spawn_schedule["spawn_limit"][spawn_level]:
		randomize()
		var spawn_index = round(rand_range(0, Database.spawn_schedule["spawn_points"][spawn_level] - 1))
		var spawn_position = SpawnPoints.get_children()[spawn_index]
		var spawn_choice = rand_range(0, 10)
		var cut1 = Database.spawn_schedule["spawn_distribution"][spawn_level][0]
		var cut2 = Database.spawn_schedule["spawn_distribution"][spawn_level][1]
		var cut3 = Database.spawn_schedule["spawn_distribution"][spawn_level][2]
		var cut4 = Database.spawn_schedule["spawn_distribution"][spawn_level][3]
		if spawn_choice >= cut1 and spawn_choice < cut2:
			EnemySpawn.spawn_monster(spawn_position.position, 1)
		elif spawn_choice >= cut2 and spawn_choice < cut3:
			EnemySpawn.spawn_monster(spawn_position.position, 2)
		elif spawn_choice >= cut3 and spawn_choice < cut4:
			EnemySpawn.spawn_monster(spawn_position.position, 3)
		elif spawn_choice > cut4:
			EnemySpawn.spawn_monster(spawn_position.position, 4)
		else:
			EnemySpawn.spawn_monster(spawn_position.position, 0)
		spawn_accumulated = 0

func _on_Timer_timeout() -> void:
	if spawn_level < Database.spawn_schedule.max_level - 1:
		spawn_level += 1
		print("spawn level is now ", str(spawn_level))

func _on_Player_player_died() -> void:
	GUIDisplay.activate_death()
