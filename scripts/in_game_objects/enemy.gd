class_name Enemy extends Node2D

const SPEED : float = 1

@onready var health_component : HealthComponent = $HealthComponent
@onready var shooting_component : ShootingComponent = $ShootingComponent
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

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
	if health_component.is_death:
		if animated_sprite.is_playing():
			return
		process_mode = Node.PROCESS_MODE_DISABLED
	var direction : Vector2 = global_position.direction_to(player_node.global_position)
	animated_sprite.flip_h = direction.x < 0
	if not attacking:
		_move()
		return
	_animate(direction)
	shooting_component.shoot(direction)

func _animate(direction : Vector2):
	direction.x = abs(direction.x)
	var angle : float = direction.angle()
	var animation_name : String = "idle_"
	if angle > PI/3:
		animation_name += "up"
	elif angle > PI/6:
		animation_name += "up45"
	elif angle > -PI/6:
		animation_name += "side"
	elif angle > -PI/3:
		animation_name += "down45"
	else:
		animation_name += "down"
	animated_sprite.play(animation_name)

func _die():
	Global.stats["money"] += 1
	animated_sprite.play("death")

func _move():
	global_position.x = move_toward(global_position.x, pos_finish, SPEED)
	if moving_right:
		if global_position.x >= pos_finish:
			_flip()
	else:
		if global_position.x <= pos_finish:
			_flip()
	return

func _flip():
	var pos_tmp : float = pos_finish
	pos_finish = pos_start
	pos_start = pos_tmp
	moving_right = not moving_right 
