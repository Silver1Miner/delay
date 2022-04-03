extends Control

onready var _clock = $VBoxContainer/Clock

func activate() -> void:
	_clock.update_clock(PlayerData.delta_time)
	PlayerData.save_game()
	$Death.visible = false
	$Close.visible = true
	get_tree().paused = true
	visible = true

func activate_death() -> void:
	if PlayerData.delta_time >= PlayerData.longest_time:
		PlayerData.longest_time = PlayerData.delta_time
	PlayerData.save_game()
	_clock.update_clock(PlayerData.delta_time)
	$Death.visible = true
	$Close.visible = false
	get_tree().paused = true
	visible = true

func _on_Quit_pressed() -> void:
	get_tree().paused = false
	if get_tree().change_scene_to(PlayerData.main_menu) != OK:
		push_error("fail to change to main menu")

func _on_Close_pressed() -> void:
	get_tree().paused = false
	visible = false
