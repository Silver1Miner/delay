extends Control

onready var quit_button = $Options/Quit
var nonquit = ["Android", "iOS", "HTML5"]

func _ready() -> void:
	if OS.get_name() in nonquit:
		quit_button.visible = false

func _on_Start_pressed() -> void:
	if get_tree().change_scene_to(PlayerData.world) != OK:
		push_error("fail to change scene")

func _on_Records_pressed() -> void:
	print("records pressed")

func _on_Settings_pressed() -> void:
	print("settings pressed")

func _on_Quit_pressed() -> void:
	get_tree().quit()
