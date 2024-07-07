extends AudioStreamPlayer

func _ready():
	finished.connect(func(): $Loop.play())
	$Loop.finished.connect(func(): $Loop.play())
