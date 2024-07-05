extends CharacterBody2D

const SPEED : float = 200
const JUMP_VELOCITY : float = -400
const COYOTE_TIME : float = 0.1

@onready var coyote_timer : Timer = $CoyoteTimer
@onready var health_component : HealthComponent = $HealthComponent

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(_delta):
	_move()

func _move():
	## Apply gravity
	if not is_on_floor():
		if sign(velocity.y) == -1:
			if Input.is_action_pressed("jump"):	
				velocity.y += gravity / 3
			else:
				velocity.y += gravity
		else:
			velocity.y += gravity / 2
	
	## Jump and fall logic
	if Input.is_action_just_pressed("jump") and (is_on_floor() or not coyote_timer.is_stopped()):
		if Input.is_action_pressed("down"):
			pass # fall through logic is in platform
		else:
			velocity.y = JUMP_VELOCITY
	
	## Sideways movement logic
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	## Apply velocity vector and update coyote timer
	move_and_slide()
	if is_on_floor(): 
		coyote_timer.start(COYOTE_TIME)
