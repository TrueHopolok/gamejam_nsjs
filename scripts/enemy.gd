class_name Enemy extends Node2D

const SPEED : float = 1

@onready var health_component : HealthComponent = $HealthComponent
@onready var shooting_component : ShootingComponent = $ShootingComponent

var player_node : Player
var pos_start : float
var pos_finish : float
var moving_right : bool = true
var attacking : bool = false

func attack_player():
	attacking = true

func _ready():
	player_node = get_tree().get_first_node_in_group("Player")
	pos_start = global_position.x
	pos_finish = $MarkerRight.global_position.x
	$MarkerRight.queue_free()
	assert(pos_start < pos_finish, name + ": Marker")

func _process(_delta):
	if not attacking:
		global_position.x = move_toward(global_position.x, pos_finish, SPEED)
		if moving_right:
			if global_position.x >= pos_finish:
				_flip()
		else:
			if global_position.x <= pos_finish:
				_flip()
	else:
		shooting_component.shoot(global_position.direction_to(player_node.global_position))

func _flip():
	var pos_tmp : float = pos_finish
	pos_finish = pos_start
	pos_start = pos_tmp
	moving_right = not moving_right 
