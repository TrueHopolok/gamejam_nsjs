extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func change_scene(scene_path : String):
	randomize()
	$Label_Motivation.text = Global.motivational_quotes[randi() % len(Global.motivational_quotes)]
	$AnimationPlayer.play("fade_to_black")
	$Timer.start(1.5)
	await $Timer.timeout
	get_tree().change_scene_to_file(scene_path)
	get_tree().paused = true
	$Timer.start(1.5)
	await $Timer.timeout
	Global.save_progress()
	$Timer.start(1.5)
	await $Timer.timeout
	get_tree().paused = false
	$AnimationPlayer.play("fade_to_normal")
