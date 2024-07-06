extends CharacterBody2D

const SPEED : float = 200
const JUMP_VELOCITY : float = -400
const COYOTE_TIME : float = 0.1

@onready var activation_area : Area2D = $ActivationArea
@onready var agro_area : Area2D = $AgroArea
@onready var coyote_timer : Timer = $CoyoteTimer
@onready var health_component : HealthComponent = $HealthComponent

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

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

func _ready():
	activation_area.area_entered.connect(func(area : Area2D): activate_enemy(area, true))
	activation_area.area_exited.connect(func(area : Area2D): activate_enemy(area, false))
	agro_area.area_entered.connect(agro_enemy)

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
