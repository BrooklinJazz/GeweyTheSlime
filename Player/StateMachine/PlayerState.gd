extends Node

class_name PlayerState

func _init():
	pass

#Functions Called From State Machine -> should be overwritten
func update_and_return(delta): 
	pass

func enter_state(host): return
func exit_state(host): return

#Functions Specific to states -> may be overwritten


#Functions used by multiple children dont need to overwrite

func handle_input_event(event):
	if event.is_echo(): return null
	return null
