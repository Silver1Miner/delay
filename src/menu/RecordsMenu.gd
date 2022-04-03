extends ColorRect

onready var _clock = $Time/Clock

func activate() -> void:
	_clock.update_clock(PlayerData.longest_time)
	_update_lore()
	visible = true

func _on_Close_pressed() -> void:
	visible = false

func _update_lore() -> void:
	$OptionButton.clear()
	for i in PlayerData.lore_collected:
		$OptionButton.add_item(titles[i])
	if $OptionButton.get_item_count() > 0:
		_on_OptionButton_item_selected(0)

func _on_OptionButton_item_selected(index: int) -> void:
	$Lore.text = entries[index]


var titles = ["That Good Night", "Black Box Entry", "Ship AI", "Star Scope"]
var entries = [

"""Do not go gentle into that good night
Old age should burn and rave at close of day
Rage, rage against the dying of the light""",

"'Critical damage to Generator detected. Energy leakage " +\
"cannot be stopped. Warning: ship components will begin to " +\
"automatically shut down. I recommend that you begin depowering the AI systems.'" +\
"\n 'No, absolutely not. That will damage you permanently, Erika.'" +\
"\n 'Captain, I appreciate your concerns, but if this continues...'"
,

"Onboard Artificial Intelligence (AI) has become " +\
"standard for most spacecraft, especially for single-pilot " +\
"craft; tracking and maintaining all the components is " +\
"simply too much for one biological brain alone to handle. " +\
"Erika is the AI of my Junker class ship. We've been through " +\
"a lot together. Her favorite color is green, " +\
"her favorite chemical element is hydrogen, " +\
"and her favorite infinite series if the sum of the natural " +\
"numbers to equal negative one twelfth."
,

"The Star Scope Project was an attempted collaboration " +\
"between the 'Big Five' Corporations CRIPK to build " +\
"a real-time monitering system of all galactic objects " +\
"for the purposes of identifying and elminating " +\
"space piracy. The project was cancelled after " +\
"a key metric only hit 9.8% that executives " +\
"wanted to reach at least 10%."
,


]
