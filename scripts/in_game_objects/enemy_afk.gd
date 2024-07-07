extends Node2D

@export var reward_on_death : int = 1

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component : HealthComponent = $HealthComponent

func _ready():
	animated_sprite.play("idle_side")
	health_component.died.connect(func():
		Global.stats["money"] += reward_on_death
		animated_sprite.play("death")
	)
	animated_sprite.animation_finished.connect(queue_free)
