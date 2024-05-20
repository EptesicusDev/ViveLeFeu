extends MultiplayerSynchronizer

@export var attacking := false
@export var direction := Vector2()
@export var state_machine: StateMachine


func _ready():
	# Only process for the local player
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


@rpc("call_local")
func attack():
	attacking = true


func _process(_delta):
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_vector("left", "right", "up", "down")
	if(direction != Vector2.ZERO):
		state_machine.current_state.transition.emit(state_machine.current_state, "Run")
	else:
		state_machine.current_state.transition.emit(state_machine.current_state, "Idle")
	if(Input.is_action_just_pressed("action")):
		pass
		# attack.rpc()
