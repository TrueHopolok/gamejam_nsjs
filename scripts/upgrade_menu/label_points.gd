extends Label

func _process(_delta):
	text = "Your upgrade points: " + str(Global.stats["money"])
