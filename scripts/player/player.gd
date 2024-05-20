class_name  Player
extends CharacterBody2D


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
	move_and_slide()


func update_animation_tree_keyboard(vector: Vector2):
	animation_tree.set("parameters/Idle/blend_position", vector)
	animation_tree.set("parameters/Run/blend_position", vector)
