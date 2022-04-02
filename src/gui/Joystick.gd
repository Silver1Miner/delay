extends Node2D

const INACTIVE_IDX = -1
export var map_to_dpad = true
onready var ball = $ball
onready var half_size = $bg.texture.get_size()/2
var direction = Vector2.ZERO
var center_point = Vector2.ZERO
var current_force = Vector2.ZERO
var ball_position = Vector2.ZERO
var squared_half_size_length = 0
var current_pointer_idx = INACTIVE_IDX

func _ready() -> void:
	map_analog_to_dpad()
	set_process_input(true)
	squared_half_size_length = half_size.x * half_size.y

func get_force() -> Vector2:
	return current_force

func _input(event) -> void:
	var incoming_pointer = extract_pointer_idx(event)
	if incoming_pointer == INACTIVE_IDX:
		display_move(event)
		return
	if need_to_change_pointer(event):
		if (current_pointer_idx != incoming_pointer) and event.is_pressed():
			current_pointer_idx = incoming_pointer;
	var same_pointer = current_pointer_idx == incoming_pointer
	if is_active() and same_pointer:
		process_input(event)

func need_to_change_pointer(event) -> bool:
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		var length = (global_position - Vector2(event.position.x, event.position.y)).length_squared();
		return length < squared_half_size_length
	return false

func is_active() -> bool:
	return current_pointer_idx != INACTIVE_IDX

func extract_pointer_idx(event) -> int:
	var touch = event is InputEventScreenTouch
	var drag = event is InputEventScreenDrag
	var mouse_button = event is InputEventMouseButton
	var mouse_move = event is InputEventMouseMotion
	if touch or drag:
		return event.index
	elif mouse_button or mouse_move:
		return 0
	else:
		return INACTIVE_IDX
		
func process_input(event) -> void:
	calculate_force(event.position.x - global_position.x, event.position.y - global_position.y)
	update_ball_position()
	if is_released(event):
		reset()

func display_move(event) -> void:
	if event.is_action_released("ui_up") or event.is_action_released('ui_down'):
		direction.y = 0
	if event.is_action_released("ui_left") or event.is_action_released('ui_right'):
		direction.x = 0
	if event.is_action_pressed("ui_right"):
		direction.x += 1
	elif event.is_action_pressed("ui_left"):
		direction.x -= 1
	if event.is_action_pressed("ui_down"):
		direction.y += 1
	elif event.is_action_pressed("ui_up"):
		direction.y -= 1
	direction = direction.normalized()
	ball_position.x = half_size.x * direction.x
	ball_position.y = half_size.y * direction.y
	ball.position = Vector2(ball_position.x, ball_position.y)

func reset() -> void:
	current_pointer_idx = INACTIVE_IDX
	calculate_force(0, 0)
	update_ball_position()

func update_ball_position():
	ball_position.x = half_size.x * current_force.x
	ball_position.y = half_size.y * -current_force.y
	ball.position = Vector2(ball_position.x, ball_position.y)

func is_pressed(event) -> bool:
	if event is InputEventMouseMotion:
		return (InputEventMouse.button_mask == 1)
	elif event is InputEventScreenTouch:
		return event.is_pressed()
	return false

func is_released(event) -> bool:
	if event is InputEventScreenTouch:
		return !event.is_pressed()
	elif event is InputEventMouseButton:
		return !event.is_pressed()
	return false

func calculate_force(var x, var y) -> void:
	current_force.x = (x - center_point.x) / half_size.x
	current_force.y = -(y - center_point.y) / half_size.y
	if current_force.length_squared()>1:
		current_force = current_force / current_force.length()
	send_signal_to_listener()

func send_signal_to_listener() -> void:
	get_tree().call_group("JoyStick", "analog_signal_change", current_force, self.get_name())
	if map_to_dpad:
		map_analog_to_dpad()

func map_analog_to_dpad() -> void:
	if current_force.x < -0.2:
		Input.action_press("ui_left")
	else:
		Input.action_release("ui_left")
	if current_force.x > 0.2:
		Input.action_press("ui_right")
	else:
		Input.action_release("ui_right")
	if current_force.y < -0.2:
		Input.action_press("ui_down")
	else:
		Input.action_release("ui_down")
	if current_force.y > 0.2:
		Input.action_press("ui_up")
	else:
		Input.action_release("ui_up")
