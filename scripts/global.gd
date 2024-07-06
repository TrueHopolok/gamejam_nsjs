extends Node

const SAVE_FILE_PATH : String = "user://covid.json"

var motivational_quotes : Array[String] = \
[
	"Don't give up!",
	"You can do it!",
	"Improve, evolve, win!",
	"Say no to losing!",
]

var stats : Dictionary = \
{
	"money" = 0,
	"health" = 0,
	"damage" = 0,
	"rpm" = 0,
	"reload" = 0,
	"ammo" = 0
}

var packed_scenes : Dictionary = \
{
	"projectile_player" = preload("res://scenes/projectiles/projectile_player.tscn"),
	"projectile_enemy" = preload("res://scenes/projectiles/projectile_enemy.tscn"),
}

func _ready():
	Engine.max_fps = 60
	for key in packed_scenes:
		assert(packed_scenes[key] != null, name + ": packed_scenes[" + key + "] is null")
	load_progress()

func reset_progress():
	stats = \
{
	"money" = 0,
	"health" = 0,
	"damage" = 0,
	"rpm" = 0,
	"reload" = 0,
	"ammo" = 0
}
	save_progress()

func load_progress():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	for key in data:
		if stats.has(key):
			stats[key] = data[key]

func save_progress():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(stats))
	file.close()
