extends Resource

var downgrades := {
	-1: {"name": "Depower AI", "max_level": 1,
	"descriptions": [
		"Decrease power supporting ship AI"
	],
	"icon": preload("res://assets/world/battery.png"),
	},
	0: {"name": "Left Gun", "max_level": 6,
	"descriptions": [
		"Degrade 1: -50% Damage",
		"Degrade 2: -50% Fire Rate",
		"Degrade 3: -20% Bullet Speed",
		"Degrade 4: -50% Damage",
		"Degrade 5: -60% Fire Rate",
		"Degrade 6: Disable Left Gun",
	],
	"icon": preload("res://assets/world/turret.png"),
	"damage": [8, 4, 4, 2, 2],
	"cooldown": [0.1, 0.1, 0.2, 0.2, 0.5],
	"speed": [200, 200, 200, 160, 160],
	"lifetime": [5.0, 5.0, 5.0, 5.0, 5.0]
	},
	1: {"name": "Right Gun", "max_level": 6,
	"descriptions": [
		"Degrade 1: -50% Damage",
		"Degrade 2: -50% Fire Rate",
		"Degrade 3: -20% Bullet Speed",
		"Degrade 4: -50% Damage",
		"Degrade 5: -60% Fire Rate",
		"Degrade 6: Disable Right Gun",
	],
	"icon": preload("res://assets/world/turret.png"),
	"damage": [8, 4, 4, 2, 2],
	"cooldown": [0.1, 0.1, 0.2, 0.2, 0.5],
	"speed": [200, 200, 200, 160, 160],
	"lifetime": [5.0, 5.0, 5.0, 5.0, 5.0]
	},
	2: {"name": "Blaze Burn", "max_level": 6,
	"descriptions": [
		"Degrade 1: -50% Damage",
		"Degrade 2: -50% Fire Rate",
		"Degrade 3: -20% Flame Speed",
		"Degrade 4: -50% Damage",
		"Degrade 5: -50% Burn Time",
		"Degrade 6: Disable Blaze Burn",
	],
	"icon": preload("res://assets/world/turret.png"),
	"damage": [8, 4, 4, 2, 2],
	"cooldown": [0.05, 0.05, 0.1, 0.1, 0.2],
	"speed": [200, 200, 200, 160, 160],
	"lifetime": [1.0, 1.0, 1.0, 1.0, 0.5]
	},
	3: {"name": "Bolt Beam", "max_level": 6,
	"descriptions": [
		"Degrade 1: -50% Damage",
		"Degrade 2: -50% Fire Rate",
		"Degrade 3: -50% Beam Time",
		"Degrade 4: -50% Damage",
		"Degrade 5: -50% Damage",
		"Degrade 6: Disable Bolt Beam",
	],
	"icon": preload("res://assets/world/turret.png"),
	"damage": [50, 25, 25, 12, 12],
	"cooldown": [1.0, 1.0, 2.0, 2.0, 2.0],
	"speed": [20, 20, 20, 20, 20],
	"lifetime": [1.0, 1.0, 1.0, 0.5, 0.5]
	},
	4: {"name": "Energy Drain", "max_level": 3,
	"descriptions": [
		"Degrade 1: -10% Energy per second",
		"Degrade 2: -20% Energy per second",
		"Degrade 3: -40% Energy per second",
	],
	"icon": preload("res://assets/world/battery.png"),
	},
}

var spawn_schedule := {
	"max_level": 6,
	"spawn_limit": [10, 12, 14, 16, 18, 20],
	"spawn_points": [4, 4, 6, 8, 12, 12],
	"spawn_pace": [100, 150, 150, 100, 80, 60],
	"spawn_distribution": [
		[9, 10, 10, 10], # Enemy2, Enemy3, Enemy4, Enemy5
		[7, 9, 10, 10],
		[3, 7, 8, 9],
		[3, 5, 7, 8],
		[0, 3, 5, 7],
		[0, 3, 5, 7],
	]
}
