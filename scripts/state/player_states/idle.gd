extends State
class_name Idle


@export var friction: float = 50


func enter() -> void:
	if(player and animation_state):
		animation_state.travel(animation_name)


func update() -> void:
	pass


func physics_update(delta: float) -> void:
	if(player):
		player.velocity = player.velocity.move_toward(Vector2.ZERO, friction * delta)


func exit() -> void:
	pass
