class_name StateMachine
extends Node


var current_state: State
var states: Dictionary = {}

@export var initial_state: State


func _ready() -> void:
	for child in self.get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_state_transistion)
	if(initial_state):
		initial_state.enter()
		current_state = initial_state

func _process(_delta: float) -> void:
	if(current_state):
		current_state.update()


func _physics_process(delta: float) -> void:
	if(current_state):
		current_state.physics_update(delta)


func on_state_transistion(state, new_state_name) -> void:
	if state != current_state:
		return
	var new_state = states.get(new_state_name)
	if(!new_state):
		return
	if(current_state):
		current_state.exit()
	new_state.enter()
	current_state = new_state
