extends AudioStreamPlayer

# MUSIC
func play_music(music_path: String, start:float = 0) -> void:
	stream = load(music_path)
	play(start)

func _ready() -> void:
	play_music("res://assets/audio/survive.ogg")
