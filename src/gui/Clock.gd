extends Label

func update_clock(delta_time) -> void:
	var seconds = int(round(delta_time))
	var minutes = seconds / 60
	var seconds_left = seconds % 60
	if minutes < 10:
		minutes = "0" + str(minutes)
	else:
		minutes = str(minutes)
	if seconds_left < 10:
		seconds_left = "0" + str(seconds_left)
	else:
		seconds_left = str(seconds_left)
	text = minutes + ":" + seconds_left + " "
