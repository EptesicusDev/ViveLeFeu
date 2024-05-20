extends State
class_name Run


func enter() -> void:
	if(player and animation_state):
		animation_state.travel(animation_name)


func update() -> void:
	pass


func physics_update() -> void:
	pass


func exit() -> void:
	pass
