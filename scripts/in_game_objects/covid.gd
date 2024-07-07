extends Node2D

@export var reward_on_death : int = 100

@onready var health_component : HealthComponent = $HealthComponent

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	health_component.died.connect(func():
		get_tree().paused
		Global.stats["money"] += reward_on_death
		$DeathAudio.play()
		await $DeathAudio.finished
		TransitionScreen.change_scene("res://scenes/menus/winner_screen.tscn")
		queue_free()
	)
