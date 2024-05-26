extends MultiplayerSynchronizer

enum PlayerStates {
	IDLE,
	RUN,
	ATTACK,
}

@export var state: PlayerStates = PlayerStates.IDLE
@export var direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


@rpc("call_local")
func attack() -> void:
	state = PlayerStates.ATTACK


func _process(_delta) -> void:
	match(state):
		PlayerStates.ATTACK:
			attack.rpc()

		_: # States that can transition immediately
			direction = Input.get_vector("left", "right", "up", "down")
			if(direction):
				state = PlayerStates.RUN
			else:
				state = PlayerStates.IDLE
			if(Input.is_action_just_pressed("attack")):
				state = PlayerStates.ATTACK
