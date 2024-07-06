extends Area2D

@export var camera_limits = Node2D

func _on_area_entered(area):
	area.get_parent().zoom = camera_limits.zoom
	area.get_parent().limit_left = camera_limits.limit_left
	area.get_parent().limit_right = camera_limits.limit_right
	area.get_parent().limit_top = camera_limits.limit_top
	area.get_parent().limit_bottom = camera_limits.limit_bottom
	area.get_parent().offset = camera_limits.offset
