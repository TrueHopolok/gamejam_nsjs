class_name Player extends CharacterBody2D

const SPEED : float = 200
const STOP_FRAMES : float = 5
const JUMP_VELOCITY : float = -400
const COYOTE_TIME : float = 0.1

@onready var activation_area : Area2D = $ActivationArea
@onready var agro_area : Area2D = $AgroArea
@onready var coyote_timer : Timer = $CoyoteTimer
@onready var health_component : HealthComponent = $HealthComponent
@onready var shooting_component : ShootingComponent = $ShootingComponent
@onready var animated_sprite = $PlayerSprite2D

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

func _process(_delta):
	_gravity()
	if health_component.is_death:
		move_and_slide()
		return
	_move()
	var direction : Vector2 = get_look_direction()
	if Input.is_action_pressed("shot"):
		shooting_component.shoot(direction)
	_animate(direction)

func _die():
	velocity.x = 0
	animated_sprite.play("death")

func _animate(direction : Vector2):
	if velocity.x: 
		animated_sprite.flip_h = velocity.x < 0
	if not is_on_floor() and coyote_timer.is_stopped():
		animated_sprite.play("jump")
		return
	var animation_name : String = "idle_"
	if velocity.x:
		animation_name = "run_"
	if direction.y > 0:
		if direction.y == 1:
			animation_name += "down"
		else:
			animation_name += "down45" 
	elif direction.y < 0:
		if direction.y == -1:
			animation_name += "up"
		else:
			animation_name += "up45"
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
