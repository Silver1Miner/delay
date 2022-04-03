extends Area2D

var active = true
export var max_hp := 100.0
export var hp := 100.0 setget set_hp
export var max_en := 100.0
export var en := 100.0 setget set_en
export var speed := 100
var velocity := Vector2.ZERO
signal hp_changed(hp, max_hp)
signal en_changed(en, max_en)
signal level_changed()
signal player_died()

func _ready() -> void:
	add_to_group("player")
	PlayerData.fresh_restart()
	emit_signal("hp_changed", hp, max_hp)
	emit_signal("en_changed", en, max_en)

# MOVEMENT
func _process(delta: float) -> void:
	if active:
		get_input()
		position += velocity * delta
		if position.x < 0 + 16:
			position.x = 0 + 16
		if position.x > 360 - 16:
			position.x = 360 - 16
		if position.y < (4 * 30) + 16:
			position.y = (4 * 30) + 16
		if position.y > (18 * 30) - 16:
			position.y = (18 * 30) - 16

func get_input() -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

# HP
func set_hp(new_hp: float) -> void:
	if new_hp > hp:
		print("heal")
	if new_hp < hp:
		print("hurt")
	hp = clamp(new_hp, 0.0, max_hp)
	emit_signal("hp_changed", hp, max_hp)
	if hp <= 0.0:
		player_death()

func player_death() -> void:
	emit_signal("player_died")
	active = false

func set_en(new_en: float) -> void:
	if new_en > en:
		print("gain energy")
	en = clamp(new_en, 0.0, max_en)
	emit_signal("en_changed", en, max_en)
	if en <= 0.0:
		PlayerData.current_level += 1
		en = max_en
		emit_signal("level_changed")
		emit_signal("en_changed", en, max_en)

# DAMAGE
func _on_Player_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemy"):
		set_hp(hp - area.get_parent().attack)

func _on_Timer_timeout() -> void:
	set_en(en - 2)

# PICKUPS
func pickup_effect(pickup_type) -> void:
	match pickup_type:
		0:
			set_en(en + 10)
