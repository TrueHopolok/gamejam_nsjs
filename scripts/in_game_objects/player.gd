class_name Player extends CharacterBody2D

const SPEED : float = 200
const STOP_FRAMES : float = 5
const JUMP_VELOCITY : float = -400
const COYOTE_TIME : float = 0.1
const SHOWING_DAMAGE_TIME : float = 0.25

@onready var activation_area : Area2D = $ActivationArea
@onready var agro_area : Area2D = $AgroArea
@onready var coyote_timer : Timer = $CoyoteTimer
@onready var health_component : HealthComponent = $HealthComponent
@onready var shooting_component : ShootingComponent = $ShootingComponent
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var damaged_timer : Timer = $DamagedTimer

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var look_direction : Vector2 = Vector2(1, 0)

func activate_enemy(area : Area2D, activate : bool):
	var parent_node = area.get_parent() 
	if is_instance_of(parent_node, Enemy):
		if activate:
			parent_node.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			parent_node.process_mode = Node.PROCESS_MODE_DISABLED

func agro_enemy(area : Area2D):
	var parent_node = area.get_parent()
	if is_instance_of(parent_node, Enemy):
		parent_node.attack_player()

func get_look_direction() -> Vector2:
	var new_direction : Vector2 = Input.get_vector("left", "right", "up", "down")
	if new_direction.length_squared() == 0: 
		if animated_sprite.flip_h:
			return Vector2(-1, 0)
		else:
			return Vector2(1, 0)
	return new_direction.normalized()

func _ready():
	activation_area.area_entered.connect(func(area : Area2D): activate_enemy(area, true))
	activation_area.area_exited.connect(func(area : Area2D): activate_enemy(area, false))
	agro_area.area_entered.connect(agro_enemy)
	health_component.died.connect(_die)
	health_component.injured.connect(func(): 
		damaged_timer.start(SHOWING_DAMAGE_TIME)
		$DamagedAudio.play()
		animated_sprite.set_modulate(Color(1, 0, 0, 1))
	)
	damaged_timer.timeout.connect(func():
		animated_sprite.set_modulate(Color(1, 1, 1, 1))
	)
	health_component.reset(
		1 + Global.stats["health"]
	)
	health_component.invincibility_timer.start(5.0)
	shooting_component.empty_clip.connect(func():
		$EmptyClipAudio.play()
	)
	shooting_component.reload.connect(func():
		$ReloadAudio.play()
	)
	shooting_component.reset(
		5 - 0.3 * Global.stats["reload"],
		1 - 0.1 * Global.stats["rpm"],
		6 + Global.stats["ammo"],
		1 + Global.stats["damage"],
	)

func _process(_delta):
	_gravity()
	if health_component.is_death:
		move_and_slide()
		return
	_move()
	var direction : Vector2 = get_look_direction()
	_animate(direction)
	if Input.is_action_pressed("shot"):
		if animated_sprite.flip_h:
			shooting_component.position.x = -4
		else:
			shooting_component.position.x = 4
		shooting_component.shoot(direction)

func _die():
	$DeathAudio.play()
	velocity.x = 0
	animated_sprite.play("death")
	$MainCamera.zoom = Vector2(3, 3)
	$DeathTimer.start(3.0)
	await $DeathTimer.timeout
	TransitionScreen.change_scene("res://scenes/menus/upgrade_menu.tscn")

func _animate(direction : Vector2):
	if velocity.x: 
		animated_sprite.flip_h = velocity.x < 0
	var animation_name : String = "idle_"	
	if not is_on_floor() and coyote_timer.is_stopped():
		animation_name = "jump_"
	elif velocity.x:
		animation_name = "run_"
	if direction.y > 0:
		if direction.y == 1:
			animation_name += "down"
		elif animation_name != "idle_":
			animation_name += "down45"
		else:
			animation_name += "down"
	elif direction.y < 0:
		if direction.y == -1:
			animation_name += "up"
		elif animation_name != "idle_":
			animation_name += "up45"
		else:
			animation_name += "up"
	else:
		animation_name += "side"
	animated_sprite.play(animation_name)

func _gravity():
	## Apply gravity
	if not is_on_floor():
		if sign(velocity.y) == -1:
			if Input.is_action_pressed("jump"):	
				velocity.y += gravity / 3
			else:
				velocity.y += gravity
		else:
			velocity.y += gravity / 2

func _move():
	## Jump and fall logic
	if Input.is_action_just_pressed("jump") and (is_on_floor() or not coyote_timer.is_stopped()):
		if Input.is_action_pressed("down"):
			pass # fall through logic is in platform
		else:
			velocity.y = JUMP_VELOCITY
	
	## Sideways movement logic
	var direction : float = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / STOP_FRAMES)
	
	## Apply velocity vector and update coyote timer
	move_and_slide()
	if is_on_floor(): 
		coyote_timer.start(COYOTE_TIME)
