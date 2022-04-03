extends Control

onready var choice1 = $Choices/Choice1
onready var choice2 = $Choices/Choice2
onready var choice3 = $Choices/Choice3
var available_downgrades = [-1,0,1,2,3,4]
var Database: Resource = preload("res://database/database.tres")

func _ready() -> void:
	deactivate()

func activate() -> void:
	if len(available_downgrades) < 3:
		available_downgrades.append(-1)
	randomize()
	available_downgrades.shuffle()
	choice1.populate_data(available_downgrades[0])
	choice2.populate_data(available_downgrades[1])
	choice3.populate_data(available_downgrades[2])
	visible = true
	get_tree().paused = true

func deactivate() -> void:
	get_tree().paused = false
	visible = false

func _on_Choice1_pressed() -> void:
	PlayerData.downgrade(choice1.downgrade_id)
	check_limits(choice1.downgrade_id)
	deactivate()

func _on_Choice2_pressed() -> void:
	PlayerData.downgrade(choice2.downgrade_id)
	check_limits(choice2.downgrade_id)
	deactivate()

func _on_Choice3_pressed() -> void:
	PlayerData.downgrade(choice3.downgrade_id)
	check_limits(choice3.downgrade_id)
	deactivate()

func check_limits(downgrade_id) -> void:
	if PlayerData.player_downgrades[downgrade_id] >= Database.downgrades[downgrade_id]["max_level"]:
		available_downgrades.erase(downgrade_id)
		print(Database.downgrades[downgrade_id]["name"] + " maxed out")
