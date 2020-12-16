extends Node

# Called when the node enters the scene tree for the first time.
class_name PlayerStateMachine

var currentPlayerState : Object = null
#var playerStateStack = [] # : Object - holds scripts not names, unused so far
onready var playerstates_map = {
	'air': PlayerStateAir,
	'ground': PlayerStateGround,
	#'grip' : $PlayerStates/PlayerStateGrip,
	#'gripUp' : $HookStates/HookStateLatched,
	#'gripLeft' : $HookStates/HookStateLatched,
	#'gripRight' : $HookStates/HookStateLatched,
	# other states named here 
}

# Called when the node enters the scene tree for the first time.
func _ready():
	currentPlayerState = playerstates_map['air']
	_enter_state('air')
	
func _physics_process(delta):
#	currentHookState.handle_input_poll(delta)  # if we switch to a polling model
	var newStateName = currentPlayerState.update_and_return(delta)
	if newStateName:
		_enter_state(newStateName)
		
func _input(event):
	var newStateName = currentPlayerState.handle_input_event(event)
	if newStateName:
		_enter_state(newStateName)
	
func _on_animation_finished():
	pass
	
func _enter_state(newStateName):
#	print("Entering: "+newStateName)
	currentPlayerState.exit_state(self)
	currentPlayerState = playerstates_map[newStateName]
	currentPlayerState.enter_state(self)

#var character
#func _init(parent):
#	character = parent
#
#func get_state():
#	return {
#		"airborne": airborne_factory(),
#		"direction": {
#			"x": x_direction_factory(),
#			"y": y_direction_factory()
#		},
#		"movement": movement_factory()
#	}
#
#func x_direction_factory():
#	var right = false
#	var center = false
#	var left = false
#	if (Input.is_action_pressed("right") and Input.is_action_pressed("left")):
#		center = true
#	elif (Input.is_action_pressed("left")):
#		left = true
#	elif (Input.is_action_pressed("right")):
#		right = true
#	else:
#		center = true
#	return {
#		"right": right,
#		"center": center,
#		"left": left
#	}
#
#func y_direction_factory():
#	var up = false
#	var down = false
#	var center = false
#	if (Input.is_action_pressed("up") and Input.is_action_pressed("down")):
#		center = true
#	elif (Input.is_action_pressed("down")):
#		down = true
#	elif (Input.is_action_pressed("up")):
#		up = true
#	else:
#		center = true
#	return {
#		"up": up,
#		"center": center,
#		"down": down
#	}
#
#func movement_factory():
#	var charge_jump = false
#	var grip = false
#	var walk = false
#	if (Input.is_action_pressed("jump")):
#		charge_jump = true
#	elif (Input.is_action_pressed("grip")):
#		grip = true
#	else:
#		walk = true
#
#	return {
#		"charge_jump": charge_jump,
#		"grip": grip,
#		"walk": walk
#	}
#
#func airborne_factory():
##	TODO - expand this factory to introduce all states
#	var jumped = false
#	var on_ceiling = false
#	var on_floor = false
#	var on_wall = false
#	var idle = false
#
#	var previous = Player.state.airborne
#	if not previous:
#		previous = {
#			"jumped": jumped,
#			"on_ceiling": on_ceiling,
#			"on_floor": on_floor,
#			"on_wall": on_wall,
#			"idle": idle
#		}
#
#	# TODO: Im here
#	if (Input.is_action_just_released("jump") and self.character.is_on_floor()):
#		jumped = true
#
#	elif character.is_on_floor() and character.is_on_wall() and Player.state.direction.y.up:
#		on_wall = true
#
#	elif character.is_on_wall() and character.is_on_floor() and not Player.state.direction.x.center:
#		on_floor = true
#
#	elif character.is_on_wall() and character.is_on_ceiling() and not Player.state.direction.x.center:
#		on_ceiling = true
#
#	elif character.is_on_ceiling() and character.is_on_wall() and Player.state.direction.y.down:
#		on_wall = true
#
#	elif character.is_on_floor() and character.is_on_wall():
#		return previous
#
#	# for some reason is_on_ceiling() is not true when upside down in the corner?
#	# so two band-aids cover for this jank
#	elif character.is_on_wall() and character.is_on_ceiling():
#		return previous
#
#	# this is a band-aid on a band-aid
#	elif previous.on_ceiling and character.is_on_wall() and Player.state.direction.y.down:
#		on_wall = true
#
#	# this is a band-aid
#	elif previous.on_ceiling and character.is_on_wall():
#		return previous
#
#	elif character.is_on_floor():
#		on_floor = true
#
#	elif character.is_on_ceiling():
#		on_ceiling = true
#
#	elif character.is_on_wall():
#		on_wall = true
#
#	return {
#		"jumped": jumped,
#		"on_ceiling": on_ceiling,
#		"on_floor": on_floor,
#		"on_wall": on_wall,
#		"on_wall_left": on_wall and wall_direction() == 'left',
#		"on_wall_right": on_wall and wall_direction() == 'right',
#		"idle": idle
#	}
#
#func wall_direction():
#	for i in range(self.character.get_slide_count()):
#		var collision = self.character.get_slide_collision(i)
#		if collision.normal.x > 0:
#			return "right"
#		elif collision.normal.x < 0:
#			return "left"
#	# return 1
