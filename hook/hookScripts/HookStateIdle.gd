extends HookState

class_name HookStateIdle


#Public Overrides
	
#func handle_input_event(event): return
	
func enter_state(host): hook.visible = false

func exit_state(host): hook.visible = true

#Private Functions
