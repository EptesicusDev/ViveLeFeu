extends Node


@onready var container = get_tree().root.get_node("Multiplayer/UI/CanvasLayer/Stack")

var row = {
	"id" = "",
	"text" = "",
	}:
	set(value):
		if(value.text == ""):
			remove_row(value.id)
		else:
			add_row(value)


func add_row(value) -> void:
	var label = Label.new()
	label.text = value.text
	label.name = value.id
	container.add_child(label)


func remove_row(id: String) -> void:
	container.get_node(id).queue_free()
