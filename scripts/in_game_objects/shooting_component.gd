class_name ShootingComponent extends Node2D
 
signal shot
signal reload_started
signal reload_finished

@export_range(0.1, 5.0) var reload_time : float = 3.0
@export_range(0.03, 1.0) var shot_interval_time : float = 0.5
@export_range(1, 100) var max_ammo_amount : int = 3

@onready var spawn_marker : Marker2D = $SpawnMarker
@onready var reload_timer : Timer = $ReloadTimer
@onready var interval_timer : Timer = $IntervalTimer

var damage : float = 1.0
var ammo_left : int = max_ammo_amount
var is_enemy : bool

func _ready():
	is_enemy = is_instance_of(get_parent(), Enemy)
	reload_timer.timeout.connect(func():
		reload_finished.emit()
		ammo_left = max_ammo_amount
	)

func reset(new_reload_time : float, new_shot_interval_time : float, new_max_ammo_amount : int, new_damage : float):
	reload_time = new_reload_time
	shot_interval_time = new_shot_interval_time
	max_ammo_amount = new_max_ammo_amount
	ammo_left = max_ammo_amount
	damage = new_damage

func shoot(target_direction : Vector2):
	if not reload_timer.is_stopped() or not interval_timer.is_stopped():
		return
	spawn_marker.position = target_direction * spawn_marker.position.length()
	var projectile_node : Projectile
	if is_enemy:
		projectile_node = Global.packed_scenes["projectile_enemy"].instantiate()
	else:
		projectile_node = Global.packed_scenes["projectile_player"].instantiate()
	get_tree().get_root().add_child(projectile_node)
	projectile_node.global_position = spawn_marker.global_position
	projectile_node.direction = target_direction
	projectile_node.damage = damage
	shot.emit()
	interval_timer.start(shot_interval_time)
	ammo_left -= 1
	if ammo_left <= 0:
		reload_started.emit()
		reload_timer.start(reload_time)
	
