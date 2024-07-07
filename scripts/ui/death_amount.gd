extends Label

func _ready():
	text = "In total uou died:\n" + str(Global.stats["death"]) + " times"
