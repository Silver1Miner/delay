extends Control

func activate() -> void:
	get_tree().paused = true
	visible = true


func _on_Quit_pressed() -> void:
	get_tree().paused = false
	if get_tree().change_scene_to(PlayerData.main_menu) != OK:
		push_error("fail to change to main menu")


func _on_Close_pressed() -> void:
	get_tree().paused = false
	visible = false
