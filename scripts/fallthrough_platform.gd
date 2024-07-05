extends StaticBody2D

@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var disable_area : Area2D = $Area2D

func _process(_delta):
	if Input.is_action_just_pressed("jump") \
	and Input.is_action_pressed("down"):
		collision_shape.disabled = true
	elif len(disable_area.get_overlapping_bodies()) == 0:
		collision_shape.disabled = false
