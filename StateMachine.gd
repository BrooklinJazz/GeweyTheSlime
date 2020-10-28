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
	if (Input.is_action_pressed("jump")):
		return Enums.Movement.JUMP_CHARGE
	elif (Input.is_action_pressed("grip")):
		return Enums.Movement.GRIP
	else:
		return Enums.Movement.WALK
		
func airborne_factory():
#	TODO - expand this factory to introduce all states
	if (Input.is_action_just_released("jump") and self.character.is_on_floor()):
		return Enums.Airborne.JUMPED
	elif (self.character.is_on_ceiling()):
		return Enums.Airborne.ON_CEILING
	
	# TODO - touching both at once causes fast switching between states
	elif (self.character.is_on_floor()):
		return Enums.Airborne.ON_FLOOR
	elif (self.character.is_on_wall()):
		return Enums.Airborne.ON_WALL
	else:
		return Enums.Airborne.IDLE
