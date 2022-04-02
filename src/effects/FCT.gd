extends Label

func show_value(value: String, travel: Vector2, duration, spread, crit=false, crit_color=Color(1,0,0)):
	text = value
	if crit:
		text += "!"
	var move = travel.rotated(rand_range(-spread/2,spread/2))
	rect_pivot_offset = rect_size/2
	$Tween.interpolate_property(self, "rect_position",
		rect_position, rect_position + move,
		duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a",
		1.0, 0.0, duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	if crit:
		modulate = crit_color
		$Tween.interpolate_property(self, "rect_scale",
			rect_scale*1.5, rect_scale,
			0.4, Tween.TRANS_BACK, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_all_completed() -> void:
	queue_free()
