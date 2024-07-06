extends ConfirmationDialog

func _ready():
	confirmed.connect(_confirmed)

func _confirmed():
	Global.reset_progress()
