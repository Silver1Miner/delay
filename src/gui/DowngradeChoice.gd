extends Button

var downgrade_id = 0
onready var title = $Info/Header/Title
onready var level = $Info/Header/Level
onready var description = $Info/Description
onready var downgrade_icon = $Info/Header/Icon
var Database: Resource = preload("res://database/database.tres")

func populate_data(new_id) -> void:
	downgrade_id = new_id
	if downgrade_id in Database.downgrades:
		title.text = Database.downgrades[downgrade_id]["name"]
		var l = PlayerData.player_downgrades[downgrade_id]
		level.text = str(l+1)
		if l < Database.downgrades[downgrade_id]["descriptions"].size():
			description.text = Database.downgrades[downgrade_id]["descriptions"][l]
		else:
			description.text = Database.downgrades[downgrade_id]["descriptions"][0]
		downgrade_icon.set_texture(Database.downgrades[downgrade_id]["icon"])
