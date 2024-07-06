class_name HealthComponent extends Node

signal injured
signal died

@export_range(0.0, 1.0) var invincibility_time : float = 0
@export_range(0.1, 10.0) var max_health : float = 1

@onready var hitbox : Area2D = $HitboxArea2D
@onready var invincibility_timer : Timer = $InvincibilityTimer

var is_death : bool = false
var health : float

func health_reset(new_max_health : float = max_health):
	hitbox.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	is_death = false
	max_health = new_max_health
	health = max_health

func _ready():
	assert(hitbox.get_child(0).shape != null, get_parent().name + ": Hitbox: Shape")
	hitbox.area_entered.connect(_damaged)
	health = max_health

func _damaged(area : Area2D):
	if not invincibility_timer.is_stopped():
		return
	if not is_instance_of(area, Projectile):
		return
	health -= area.damage
	is_death = health <= 0.0
	invincibility_timer.start(invincibility_time)
	if is_death:
		died.emit()
		hitbox.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	else:
		injured.emit()
