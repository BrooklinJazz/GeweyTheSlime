extends HookState

class_name HookStateAirOut

var localLaunchRange

#Public Overrides
func update_and_return(delta):
	.update_and_return(delta)
	if sharedVars.hit:
		return "latched"
	if hook.global_position.distance_to(player.global_position) > localLaunchRange:
		sharedVars.currentMovement = Vector2(0.0,0.0)
		return "airIn"
	return null
	
#func handle_input_event(event): pass
	
func enter_state(host): 
	localLaunchRange = sharedVars.launchRange

func exit_state(host): return

#Private Functions
func _move_hook(delta):
	hook.rotation = hook.global_position.angle_to_point(player.global_position) + deg2rad(90)
	var extension = (sharedVars.launchRange-hook.global_position.distance_to(player.global_position))/sharedVars.launchRange
	sharedVars.currentMovement.x -= slowingFactor * (1-extension) * delta
	sharedVars.currentMovement.y += delta * gravity
	sharedVars.hit = hook.move_and_collide(sharedVars.currentMovement*delta)
