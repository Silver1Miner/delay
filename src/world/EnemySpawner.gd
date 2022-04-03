extends Node2D

export (PackedScene) var Enemy = preload("res://src/enemy/Enemy.tscn")
export (PackedScene) var Enemy2 = preload("res://src/enemy/Enemy.tscn")
export (PackedScene) var Enemy3 = preload("res://src/enemy/Enemy.tscn")
export (PackedScene) var Enemy4 = preload("res://src/enemy/Enemy.tscn")
export (PackedScene) var Enemy5 = preload("res://src/enemy/Enemy.tscn")

func spawn_monster(spawn_position, type) -> void:
	var monster
	match type:
		0:
			monster = Enemy.instance()
		1:
			monster = Enemy2.instance()
		2:
			monster = Enemy3.instance()
		3:
			monster = Enemy4.instance()
		4:
			monster = Enemy5.instance()
	randomize()
	monster.position = spawn_position
	add_child(monster)
