class_name Projectile extends Area2D

const SPEED : float = 3

var damage : float = 1.0
var velocity : Vector2

func _ready():
	area_entered.connect(func(_area : Area2D): queue_free())
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)
	velocity *= SPEED
	print(damage, velocity)

func _process(_delta):
	global_position += velocity
