extends Node
class_name State

signal transition

@export var animation_tree: AnimationTree
@export var player: Player
@export var animation_name: String
@export var synchronized_input: MultiplayerSynchronizer

@onready var animation_state = animation_tree["parameters/playback"]


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter() -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update() -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
