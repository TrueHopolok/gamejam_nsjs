extends Node

const SAVE_FILE_PATH : String = "user://covid.json"

var motivational_quotes : Array[String] = \
[
	## Motivation:
	"Don't give up!",
	"You can do it!",
	"Improve, evolve, win!",
	"Become stronger, adapt!",
	## Qoutes:
	"What doesn’t kill us makes us stronger!",
	"Winners never quit, and quitters never win.",
	"90% precent of gamblers quit before they hit big.",
	## Hints:
	"Enemy with full armor:\nHas 10 health points and shoots like a regular enemy, but faster.",
	"Kevlar enemy:\nHas 7 health points and shoots every second.",
	"Helmet enemy:\nHas 4 health points and shoots in burst of 3 bullets.",
]

var stats : Dictionary = \
{
	"death" = 0,
	"money" = 0,
	"health" = 0,
	"damage" = 0,
	"rpm" = 0,
	"reload" = 0,
	"ammo" = 0
}

var shooting_streams : Array[AudioStream] = \
[
	preload("res://sound/shot_sound_1.wav"),
	preload("res://sound/shot_sound_2.wav"),
	preload("res://sound/shot_sound_3.wav"),
	preload("res://sound/shot_sound_4.wav"),
	preload("res://sound/shot_sound_5.wav"),
	preload("res://sound/shot_sound_6.wav"),
]

var packed_scenes : Dictionary = \
{
	"projectile_player" = preload("res://scenes/projectiles/projectile_player.tscn"),
	"projectile_enemy" = preload("res://scenes/projectiles/projectile_enemy.tscn"),
}

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Engine.max_fps = 60
	for key in packed_scenes:
		assert(packed_scenes[key] != null, name + ": packed_scenes[" + key + "] is null")
	load_progress()

func reset_progress():
	stats = \
{
	"death" = 0,
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
