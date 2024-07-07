extends TextureButton

@onready var progress_bar : ProgressBar = $ProgressBar

var info_label : RichTextLabel

func _ready():
	info_label = get_tree().get_first_node_in_group("Info")

func _process(_delta):
	progress_bar.value = clampi(Global.stats["damage"], 0, 9)
	if is_hovered():
		if Global.stats["damage"] < 9:
			info_label.text = \
"Upgrading this will increase your [color=green]damage[/color] by [color=green]1[/color].\n
Cost for an upgrade: [color=red]" + str(Global.stats["damage"] * 2 + 2) + "[/color]."
		else:
			info_label.text = "[color=green]Damage[/color] upgrade is [color=yellow]maxed out[/color]."

func _pressed():
	if Global.stats["damage"] >= 9:
		return
	if Global.stats["money"] - Global.stats["damage"] * 2 - 2 < 0:
		return
	Global.stats["money"] -= Global.stats["damage"] * 2 + 2
	Global.stats["damage"] += 1
