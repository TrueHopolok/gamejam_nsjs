extends Button

@onready var progress_bar : ProgressBar = $ProgressBar

var info_label : RichTextLabel

func _ready():
	info_label = get_tree().get_first_node_in_group("Info")

func _process(_delta):
	progress_bar.value = clampi(Global.stats["ammo"], 0, 9)
	if is_hovered():
		if Global.stats["ammo"] < 9:
			info_label.text = \
"Upgrading this will increase your [color=green]ammo amount[/color] by [color=green]1 bullet[/color].\n
Cost for an upgrade: [color=red]" + str(Global.stats["ammo"] * 2 + 2) + "[/color]."
		else:
			info_label.text = "[color=green]Ammo[/color] upgrade is [color=yellow]maxed out[/color]."

func _pressed():
	if Global.stats["ammo"] >= 9:
		return
	if Global.stats["money"] - Global.stats["ammo"] * 2 - 2 < 0:
		return
	Global.stats["money"] -= Global.stats["ammo"] * 2 + 2
	Global.stats["ammo"] += 1
