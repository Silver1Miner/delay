extends ParallaxBackground

export var velocity := Vector2(0, 30)

func _process(delta: float) -> void:
	var new_offset: Vector2 = get_scroll_offset() + velocity * delta
	set_scroll_offset(new_offset)
