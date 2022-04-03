extends Control

onready var hp_bar = $Status/Bars/HPDisplay/HPBar
onready var en_bar = $Status/Bars/ENDisplay/ENBar
onready var level_text = $Status/Bars/Status/Level
onready var joystick = $Controls/Joystick

func _on_Pause_pressed() -> void:
	$PauseScreen.activate()

func _on_Player_hp_changed(new_hp, _max_hp) -> void:
	#hp_bar.max_value = _max_hp
	hp_bar.value = new_hp

func _on_Player_en_changed(new_en, max_en) -> void:
	en_bar.max_value = max_en
	en_bar.value = new_en

func _on_Player_level_changed() -> void:
	level_text.text = "Degradation Level: " + str(PlayerData.current_level)
	joystick.reset()

func update_clock(delta_time: float) -> void:
	$Status/Bars/Status/Clock.update_clock(delta_time)
