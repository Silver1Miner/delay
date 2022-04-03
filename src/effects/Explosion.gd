extends AnimatedSprite

func _ready() -> void:
	$AudioStreamPlayer2D.play()
	play()

func _on_AudioStreamPlayer2D_finished() -> void:
	queue_free()

func mute() -> void:
	$AudioStreamPlayer2D.volume_db = -100
