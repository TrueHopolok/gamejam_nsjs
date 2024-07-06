class_name Enemy extends Node2D

const SPEED : float = 1

@onready var health_component : HealthComponent = $HealthComponent

var pos_start : float
var pos_finish : float
var moving_right : bool = true

func attack_player():
	print(name, ": attack player")

func _ready():
	pos_start = global_position.x
	pos_finish = $MarkerRight.global_position.x
	$MarkerRight.queue_free()
	assert(pos_start < pos_finish, name + ": Marker")

func _process(_delta):
	global_position.x = move_toward(global_position.x, pos_finish, SPEED)
	if moving_right:
		if global_position.x >= pos_finish:
			_flip()
	else:
		if global_position.x <= pos_finish:
			_flip()

func _flip():
	var pos_tmp : float = pos_finish
	pos_finish = pos_start
	pos_start = pos_tmp
	moving_right = not moving_right 
