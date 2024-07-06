class_name Projectile extends Area2D

@export var speed : float = 3

var damage : float = 1.0
var direction : Vector2

func _ready():
	area_entered.connect(func(area : Area2D): 
		if is_instance_of(area, Projectile): return
		else: queue_free()
	)
	body_entered.connect(func(_body): queue_free())
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)

func _process(_delta):
	global_position += direction * speed
