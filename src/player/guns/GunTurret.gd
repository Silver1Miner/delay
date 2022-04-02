extends Node2D

export var gun_id = 0
export var attack_damage := 1.0
export var attack_cooldown := 1.0
export var projectile_speed := 100.0
export var projectile_lifetime := 10.0
export var hit_radius := 20
export var blast_radius := 32
export (PackedScene) var Bullet = preload("res://src/player/guns/Bullet.tscn")
onready var _laser_sight := $Line2D
onready var _attack_range := $AttackRange
onready var _raycast := $RayCast2D
onready var _cooldown_timer := $Timer

func _ready() -> void:
	_laser_sight.add_point(Vector2.ZERO)
	_laser_sight.add_point(Vector2.ZERO)
	_laser_sight.default_color = Color(1, 0, 1)

func _process(_delta: float) -> void:
	if not visible:
		return
	var targets: Array = _attack_range.get_overlapping_areas()
	if targets.empty():
		_laser_sight.points[1] = Vector2.ZERO
		return
	var target
	for t in targets:
		if t.get_parent().is_in_group("enemy"):
			target = t
			break
	if target != null:
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
