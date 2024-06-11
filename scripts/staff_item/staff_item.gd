class_name Staff
extends StaticBody2D


@export var color: Color


func  _ready() -> void:
	$Sprite2D.self_modulate = color
