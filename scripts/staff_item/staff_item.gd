class_name Staff
extends StaticBody2D


@export var color: Color


func  _ready() -> void:
	self.rotation = deg_to_rad(randi_range(0, 4) * 90)
	$Sprite2D.self_modulate = color
