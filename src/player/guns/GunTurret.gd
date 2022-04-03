extends Node2D

export var can_turn = true
export var gun_id = 0
export var attack_damage := 4.0
export var attack_cooldown := 0.1
export var projectile_speed := 100.0
export var projectile_lifetime := 10.0
export var hit_radius := 20
export var blast_radius := 32
export (PackedScene) var Bullet = preload("res://src/player/guns/Bullet.tscn")
export var shot_sound = preload("res://assets/audio/shot.ogg")
onready var _laser_sight := $Line2D
onready var _attack_range := $AttackRange
onready var _raycast := $RayCast2D
onready var _cooldown_timer := $Timer
var current_level = -1
var Database: Resource = preload("res://database/database.tres")

func _ready() -> void:
	_laser_sight.add_point(Vector2.ZERO)
	_laser_sight.add_point(Vector2.ZERO)
	_laser_sight.default_color = Color(1, 0, 1)
	$AudioStreamPlayer2D.stream = shot_sound
	update_level()

# DOWNGRADE
func update_level() -> void:
	var new_level = PlayerData.player_downgrades[gun_id]
	if visible and new_level != current_level:
		print("downgrade ", Database.downgrades[gun_id]["name"], " to level ", new_level)
		current_level = new_level
		visible = current_level < Database.downgrades[gun_id]["max_level"]
		if current_level < len(Database.downgrades[gun_id]["damage"]):
			attack_damage = Database.downgrades[gun_id]["damage"][PlayerData.player_downgrades[gun_id]]
		if current_level < len(Database.downgrades[gun_id]["cooldown"]):
			attack_cooldown = Database.downgrades[gun_id]["cooldown"][PlayerData.player_downgrades[gun_id]]
		if current_level < len(Database.downgrades[gun_id]["speed"]):
			projectile_speed = Database.downgrades[gun_id]["speed"][PlayerData.player_downgrades[gun_id]]
		if current_level < len(Database.downgrades[gun_id]["lifetime"]):
			projectile_lifetime = Database.downgrades[gun_id]["lifetime"][PlayerData.player_downgrades[gun_id]]

func _process(_delta: float) -> void:
	if not visible:
		return
	var targets: Array = _attack_range.get_overlapping_areas()
	if targets.empty():
		_laser_sight.points[1] = Vector2.ZERO
		return
	var target = null
	if can_turn:
		for t in targets:
			if t.get_parent().is_in_group("enemy"):
				target = t
				break
	else:
		if _raycast.is_colliding():
			target = _raycast.get_collider()
	if target != null:
		if can_turn:
			$Sprite.look_at(target.global_position)
			_raycast.cast_to = target.global_position - global_position
			_raycast.force_raycast_update()
			_laser_sight.points[1] = target.global_position - global_position
		if target.get_parent() and _cooldown_timer.is_stopped():
			if target.get_global_position().y < (18 * 30) - 16 and \
			target.get_global_position().y > (4 * 30) + 16 and \
			target.get_global_position().x > 0 + 16 and \
			target.get_global_position().x < 360 - 16:
				shoot_at()
	else:
		_laser_sight.points[1] = Vector2.ZERO

func shoot_at() -> void:
	$AudioStreamPlayer2D.play()
	var bullet_instance = Bullet.instance()
	get_parent().get_parent().add_child(bullet_instance)
	bullet_instance.set_hit_blast(hit_radius, blast_radius)
	bullet_instance.speed = projectile_speed
	bullet_instance.set_timer(projectile_lifetime)
	var angle = _raycast.cast_to.angle()
	bullet_instance.rotation = angle
	bullet_instance.global_position = get_global_position() + 16*Vector2(cos(angle),sin(angle))
	bullet_instance.damage = attack_damage
	_cooldown_timer.start(attack_cooldown)
