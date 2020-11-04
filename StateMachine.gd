extends Node

# Called when the node enters the scene tree for the first time.
class_name PlayerStateMachine

var character
func _init(parent):
	character = parent
	
func get_state():
	return {
		"airborne": airborne_factory(),
		"direction": {
			"x": x_direction_factory(),
			"y": y_direction_factory()
		},
		"movement": movement_factory()
	}
	
func x_direction_factory():
	var right = false
	var center = false
	var left = false
	if (Input.is_action_pressed("right") and Input.is_action_pressed("left")):
		center = true
	elif (Input.is_action_pressed("left")):
		left = true
	elif (Input.is_action_pressed("right")):
		right = true
	else:
		center = true
	return {
		"right": right,
		"center": center,
		"left": left
	}

func y_direction_factory():
	var up = false
	var down = false
	var center = false
	if (Input.is_action_pressed("up") and Input.is_action_pressed("down")):
		center = true
	elif (Input.is_action_pressed("down")):
		down = true
	elif (Input.is_action_pressed("up")):
		up = true
	else:
		center = true
	return {
		"up": up,
		"center": center,
		"down": down
	}

func movement_factory():
	var charge_jump = false
	var grip = false
	var walk = false
	if (Input.is_action_pressed("jump")):
		charge_jump = true
	elif (Input.is_action_pressed("grip")):
		grip = true
	else:
		walk = true

	return {
		"charge_jump": charge_jump,
		"grip": grip,
		"walk": walk
	}
		
func airborne_factory():
#	TODO - expand this factory to introduce all states
	var jumped = false
	var on_ceiling = false
	var on_floor = false
	var on_wall = false
	var idle = false

	var previous = Player.state.airborne
	if not previous:
		previous = {
			"jumped": jumped,
			"on_ceiling": on_ceiling,
			"on_floor": on_floor,
			"on_wall": on_wall,
			"idle": idle
		}

	# TODO: someone please help
	if (Input.is_action_just_released("jump") and self.character.is_on_floor()):
		jumped = true

	elif character.is_on_floor() and character.is_on_wall() and Player.state.direction.y.up:
		on_wall = true

	elif character.is_on_wall() and character.is_on_floor() and not Player.state.direction.x.center:
		on_floor = true

	elif character.is_on_wall() and character.is_on_ceiling() and not Player.state.direction.x.center:
		on_ceiling = true

	elif character.is_on_ceiling() and character.is_on_wall() and Player.state.direction.y.down:
		on_wall = true

	elif character.is_on_floor() and character.is_on_wall():
		return previous

	# for some reason is_on_ceiling() is not true when upside down in the corner?
	# so two band-aids cover for this jank
	elif character.is_on_wall() and character.is_on_ceiling():
		return previous

	# this is a band-aid on a band-aid
	elif previous.on_ceiling and character.is_on_wall() and Player.state.direction.y.down:
		on_wall = true

	# this is a band-aid
	elif previous.on_ceiling and character.is_on_wall():
		return previous

	elif character.is_on_floor():
		on_floor = true

	elif character.is_on_ceiling():
		on_ceiling = true

	elif character.is_on_wall():
		on_wall = true

	return {
		"jumped": jumped,
		"on_ceiling": on_ceiling,
		"on_floor": on_floor,
		"on_wall": on_wall,
		"idle": idle
	}
