extends HookState

class_name HookStateLatched


#Public Overrides
func update_and_return(delta):
	.update_and_return(delta)
	_yank_player(delta)
	return null
	
func jump_out(): return "idle"

#func handle_input_event(event): return	

func enter_state(host): return

func exit_state(host): return

#Private Functions

func _yank_player(delta):
	if (Player.state == States.Grabbed.FLOOR):
		return
	var playerPos = player.global_position
	var hookPos = hook.global_position
	Player.motion += (-delta*pow(hookPos.distance_to(playerPos), pullExpFactor)
					*pullFactor*hookPos.direction_to(playerPos))
