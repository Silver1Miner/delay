extends Control

onready var quit_button = $Options/Quit
var nonquit = ["Android", "iOS", "HTML5"]

func _ready() -> void:
	if OS.get_name() in nonquit:
		quit_button.visible = false

func _on_Start_pressed() -> void:
	PlayerData.fresh_restart()
	if get_tree().change_scene_to(PlayerData.world) != OK:
		push_error("fail to change scene")

func _on_Records_pressed() -> void:
	$RecordsMenu.activate()

func _on_Settings_pressed() -> void:
	$SettingsMenu.visible = true

func _on_Quit_pressed() -> void:
	get_tree().quit()
