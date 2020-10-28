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
	var direction = {
		"right": false,
		"left": false,
		"center": false
	}
	if (Input.is_action_pressed("right") and Input.is_action_pressed("left")):
		direction.center = true
	elif (Input.is_action_pressed("left")):
		direction.left = true
	elif (Input.is_action_pressed("right")):
		direction.right = true
	else:
		direction.center = true
	return direction

func y_direction_factory():
	if (Input.is_action_pressed("up") and Input.is_action_pressed("down")):
		return Enums.Direction.CENTER
	elif (Input.is_action_pressed("down")):
		return Enums.Direction.DOWN
	elif (Input.is_action_pressed("up")):
		return Enums.Direction.UP
	else:
		return Enums.Direction.CENTER


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
