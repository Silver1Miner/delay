extends Button

var downgrade_id = 0
onready var title = $Info/Header/Title
onready var level = $Info/Header/Level
onready var description = $Info/Description
onready var downgrade_icon = $Info/Header/Icon

func populate_data(new_id) -> void:
	downgrade_id = new_id
