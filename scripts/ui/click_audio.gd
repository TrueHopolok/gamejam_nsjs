extends AudioStreamPlayer

func _ready():
	get_parent().pressed.connect(func(): play())
