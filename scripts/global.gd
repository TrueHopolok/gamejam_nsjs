extends Node

var packed_scenes : Dictionary = \
{
	"projectile_player" = preload("res://scenes/projectiles/projectile_player.tscn"),
	"projectile_enemy" = preload("res://scenes/projectiles/projectile_enemy.tscn"),
}

func _ready():
	Engine.max_fps = 60
	for key in packed_scenes:
		assert(packed_scenes[key] != null, name + ": packed_scenes[" + key + "] is null")
