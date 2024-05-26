class_name  Player
extends CharacterBody2D


const SPEED = 75
const FRICTION = 375
const ACCELERATION = 300

enum PlayerStates {
	IDLE,
	RUN,
	ATTACK,
}

# Set by the authority, synchronized on spawn.
@export var player: int = 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$PlayerInput.set_multiplayer_authority(id)

@onready var input: MultiplayerSynchronizer = $PlayerInput
@onready var camera: Camera2D = $Camera2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine = $AnimationTree["parameters/playback"]


func _ready() -> void:
	if(player == multiplayer.get_unique_id()):
		camera.enabled = true
		$Label.visible = true
	# Only process on server.
	# EDIT: Left the client simulate player movement too to compesate network latency.
	# set_physics_process(multiplayer.is_server())


func _physics_process(delta) -> void:
	var direction = Vector2(input.direction.x, input.direction.y).normalized()
	match(input.state):
		PlayerStates.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

		PlayerStates.RUN:
			velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
			velocity.y = move_toward(velocity.y, direction.y * SPEED, ACCELERATION * delta)
			update_animation_tree_keyboard(direction)

		PlayerStates.ATTACK:
			input.state = PlayerStates.IDLE

		_:
			pass
	move_and_slide()


func _process(_delta):
	match(input.state):
		PlayerStates.IDLE:
			animation_state_machine.travel("Idle")

		PlayerStates.RUN:
			animation_state_machine.travel("Run")

		PlayerStates.ATTACK:
			pass

		_:
			pass


func update_animation_tree_keyboard(vector: Vector2) -> void:
	# Add each new animation with BlendSpace2D here
	animation_tree.set("parameters/Idle/blend_position", vector)
	animation_tree.set("parameters/Run/blend_position", vector)
