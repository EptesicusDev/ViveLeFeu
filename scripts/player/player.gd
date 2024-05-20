class_name  Player
extends CharacterBody2D

const SPEED = 100

# Set by the authority, synchronized on spawn.
@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$PlayerInput.set_multiplayer_authority(id)

@onready var input = $PlayerInput
@onready var camera = $Camera2D
@onready var animation_tree = $AnimationTree


func _ready():
	# Set the camera as current if we are this player.
	if player == multiplayer.get_unique_id():
		camera.enabled = true
		$Label.visible = true
	# Only process on server.
	# EDIT: Left the client simulate player movement too to compesate network latency.
	# set_physics_process(multiplayer.is_server())


func _physics_process(_delta):
	# Handle movement.
	var direction = Vector2(input.direction.x, input.direction.y).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
		update_animation_tree_keyboard(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()


func update_animation_tree_keyboard(vector: Vector2):
	animation_tree.set("parameters/Idle/blend_position", vector)
	animation_tree.set("parameters/Run/blend_position", vector)
