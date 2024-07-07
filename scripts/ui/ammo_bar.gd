extends ProgressBar

var player_node : Player

func _ready():
	player_node = get_tree().get_first_node_in_group("Player")

func _process(_delta):
	if player_node == null:
		value = 0
	else:
		value = 100 * player_node.shooting_component.ammo_left / player_node.shooting_component.max_ammo_amount
