extends Node2D

export var speed := 50
export var lifetime := 1.0
export var damage := 10.0
export var explosion_scale := 0.5
export var explode_on_timeout = false
export var explode_on_hit = true
export var has_explosion_effect = true
onready var _timer := $Timer
onready var _blast_range := $BlastArea
var target_position := Vector2.ZERO
export (PackedScene) var Explosion = preload("res://src/effects/Explosion.tscn")


func set_timer(new_lifetime: float) -> void:
	_timer.wait_time = new_lifetime
	_timer.start()

func set_hit_blast(hit_radius: float, blast_radius: float) -> void:
	$Hitbox/CollisionShape2D.shape.radius = hit_radius
	$BlastArea/CollisionShape2D.shape.radius = blast_radius

func _process(delta: float) -> void:
	position += Vector2(cos(rotation), sin(rotation)) * speed * delta

func _on_Timer_timeout() -> void:
	if explode_on_timeout:
		explode()
	else:
		queue_free()

func explode() -> void:
	if has_explosion_effect:
		var explosion_instance = Explosion.instance()
		get_parent().add_child(explosion_instance)
		explosion_instance.position = get_global_position()
		explosion_instance.scale = Vector2(explosion_scale, explosion_scale)
	var targets: Array = _blast_range.get_overlapping_areas()
	for t in targets:
		if t.get_parent().is_in_group("enemy"):
			if t.get_parent().has_method("take_damage"):
				t.get_parent().take_damage(damage)
	queue_free()

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemy"):
		if explode_on_hit:
			explode()
		else:
			pierce(area)

func pierce(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemy"):
		if area.get_parent().has_method("take_damage"):
			area.get_parent().take_damage(damage)
