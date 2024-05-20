extends State
class_name Run


@export var speed: float
@export var acceleration: float


func enter() -> void:
	if(player and animation_state):
		animation_state.travel(animation_name)


func update() -> void:
	pass


func physics_update(delta: float) -> void:
	var direction = Vector2(synchronized_input.direction.x, synchronized_input.direction.y).normalized()
	if direction:
		player.velocity.x = move_toward(player.velocity.x, direction.x * speed, acceleration * delta)
		player.velocity.y = move_toward(player.velocity.y, direction.y * speed, acceleration * delta)
		player.update_animation_tree_keyboard(direction)


func exit() -> void:
	pass
