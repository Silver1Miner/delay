extends KinematicBody2D

export var max_hp := 50.0
export var hp := 50.0 setget set_hp
export var speed := 50
export var attack := 10
var velocity := Vector2.ZERO
var moving := true
onready var manager = get_parent()
var target_position := Vector2.ZERO
var direction := Vector2.ZERO
var path := PoolVector2Array() setget set_path
var invulnerable = false

export (PackedScene) var Explosion = preload("res://src/effects/Explosion.tscn")
export (PackedScene) var FCT = preload("res://src/effects/FCT.tscn")
export (PackedScene) var Pickup = preload("res://src/pickups/Pickup.tscn")
export (PackedScene) var PickupData = preload("res://src/pickups/PickupData.tscn")

func _ready() -> void:
	add_to_group("enemy")

# MOVEMENT
var move_accumulated = 0
var cooldown = 0.5
func _process(delta: float) -> void:
	if moving:
		var move_distance := speed * delta
		move_along_path(move_distance)
		move_accumulated += delta
		if move_accumulated > cooldown:
			find_target()
			move_accumulated = 0
	for a in $Hitbox.get_overlapping_areas():
		if a.is_in_group("player"):
			a.set_hp(a.hp - attack * delta)


func find_target() -> void:
	if manager and manager.get_parent() and manager.get_parent().has_node("Player"):
		target_position = manager.get_parent().get_node("Player").position
		direction = (target_position - position).normalized()
		set_path(manager.get_parent().get_simple_path(position, target_position))
	else:
		print("no target")

func set_path(value: PoolVector2Array) -> void:
	path = value
	if value.size() == 0:
		return
	moving = true

func move_along_path(distance: float) -> void:
	var start_point = position
	for _i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance > 0.0:
			#position = start_point.linear_interpolate(path[0], distance/distance_to_next)
			velocity = (path[0]-start_point).normalized() * speed + Vector2(0,20)
			velocity = move_and_slide(velocity)
			look_at(path[0])
			break
		elif distance < 0.0:
			position = path[0]
			moving = false
			#set_process(false)
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)

# HP
func set_hp(new_hp: float) -> void:
	hp = clamp(new_hp, 0.0, max_hp)
	if hp <= 0:
		die()

func die() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	drop()
	create_explosion()
	queue_free()

func take_damage(damage_value: float) -> void:
	if invulnerable:
		return
	var fct = FCT.instance()
	if manager and manager.get_parent():
		manager.get_parent().add_child(fct)
	fct.rect_position = get_global_position() + Vector2(0, -16)
	fct.show_value(str(round(damage_value)), Vector2(0,-8), 1, PI/2)
	set_hp(hp - damage_value)

# EFFECTS
func drop() -> void:
	if manager and manager.get_parent():
		randomize()
		var drop_choice = rand_range(0, 25)
		if drop_choice > 0 and PlayerData.lore_collected < PlayerData.max_lore:
			var pickup_instance = PickupData.instance()
			manager.get_parent().get_node("Drops").call_deferred("add_child",pickup_instance)
			pickup_instance.position = get_global_position()
		elif drop_choice > 20:
			var pickup_instance = Pickup.instance()
			manager.get_parent().get_node("Drops").call_deferred("add_child",pickup_instance)
			pickup_instance.position = get_global_position()

func create_explosion() -> void:
	if manager and manager.get_parent():
		var explosion_instance = Explosion.instance()
		manager.get_parent().add_child(explosion_instance)
		explosion_instance.position = get_global_position()
