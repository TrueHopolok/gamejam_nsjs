class_name HealthComponent extends Node

signal injured
signal died

@export_range(0.0, 1.0) var invincibility_time : float = 0
@export_range(0.1, 10.0) var max_health : float = 1

@onready var hitbox : Area2D = $HitboxArea2D
@onready var invincibility_timer : Timer = $InvincibilityTimer

var health : float = max_health

func health_reset(new_max_health : float = max_health):
	max_health = new_max_health
	health = max_health

func _ready():
	assert(hitbox.get_child(0).shape != null, get_parent().name + ": Hitbox: Shape")
	hitbox.area_entered.connect(_damaged)

func _damaged(area : Area2D):
	if not invincibility_timer.is_stopped():
		return
	var parent_node = area.get_parent()
	if not is_instance_of(parent_node, Projectile):
		return
	health -= parent_node.damage
	invincibility_timer.play(invincibility_time)
	if health <= 0.0:
		died.emit()
	else:
		injured.emit()
