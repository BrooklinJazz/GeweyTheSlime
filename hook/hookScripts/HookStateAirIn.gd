extends HookState

class_name HookStateAirIn


#Public Overrides
func update_and_return(delta):
	.update_and_return(delta)
	if sharedVars.hit:
		return "latched"
	if hook.position.distance_to(player.global_position) < 8:
		sharedVars.currentMovement = Vector2.ZERO
		return "idle"
	return null
	
#func handle_input_event(event): pass
	
func enter_state(host): return

func exit_state(host): return

#Private Functions
func _move_hook(delta):
	var playerPos = player.global_position
	var hookPos = hook.global_position
	hook.rotation = hookPos.angle_to_point(playerPos) + deg2rad(90)
	var speed = sharedVars.currentMovement.length()
#	sharedVars.currentMovement *= 0.95
	sharedVars.currentMovement = hookPos.direction_to(playerPos) * 500
	sharedVars.hit = hook.move_and_collide(sharedVars.currentMovement*delta)

