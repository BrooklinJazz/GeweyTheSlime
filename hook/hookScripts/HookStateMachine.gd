extends Node2D

class_name HookStateMachine

var currentHookState : Object = null
var hookStateStack = [] # : Object - holds scripts not names, unused so far
onready var hookstates_map = {
	'idle' : $HookStates/HookStateIdle,
	'airOut': $HookStates/HookStateAirOut,
	'airIn' : $HookStates/HookStateAirIn,
	'latched' : $HookStates/HookStateLatched,
	# other states named here 
}

# Called when the node enters the scene tree for the first time.
func _ready():
	currentHookState = hookstates_map['idle']
	_enter_state('idle')
	
func _physics_process(delta):
#	currentHookState.handle_input_poll(delta)  # if we switch to a polling model
	var newStateName = currentHookState.update_and_return(delta)
	if newStateName:
		_enter_state(newStateName)
		
func _input(event):
	var newStateName = currentHookState.handle_input_event(event)
	if newStateName:
		_enter_state(newStateName)
	
func _on_animation_finished():
	pass
	
func _enter_state(newStateName):
#	print("Entering: "+newStateName)
	currentHookState.exit_state(self)
	currentHookState = hookstates_map[newStateName]
	currentHookState.enter_state(self)
