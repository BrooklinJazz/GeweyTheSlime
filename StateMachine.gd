extends Node

enum Direction {
	LEFT,
	RIGHT,
	CENTER
}

enum Movement {
	WALK,
	GRIP,
	JUMP_CHARGE
}

enum Airborn {
	RISING,
	FALLING,
	ON_FLOOR,
	ON_CEILING,
	JUMPED,
	ON_WALL,
	IDLE
}


# Called when the node enters the scene tree for the first time.
class_name PlayerStateMachine

var movement = Movement.WALK
var direction = Direction.CENTER
var airborn = Airborn.FALLING

var character
func _init(parent):
	character = parent
	
func direction_factory():
	if (Input.is_action_pressed("right") and Input.is_action_pressed("left")):
		return Direction.CENTER
	elif (Input.is_action_pressed("left")):
		return Direction.LEFT
	elif (Input.is_action_pressed("right")):
		return Direction.RIGHT
	else:
		return Direction.CENTER

func movement_factory():
	if (Input.is_action_pressed("jump")):
		return Movement.JUMP_CHARGE
	elif (Input.is_action_pressed("grip")):
		return Movement.GRIP
	else:
		return Movement.WALK
		
func airborn_factory():
#	TODO - expand this factory to introduce all states
	if (Input.is_action_just_released("jump") and self.character.is_on_floor()):
		return Airborn.JUMPED
	elif (self.character.is_on_floor()):
		return Airborn.ON_FLOOR
	elif (self.character.is_on_ceiling()):
		return Airborn.ON_CEILING
	else:
		return Airborn.IDLE
	
func create():
	return {
		"airborn": airborn_factory(),
		"direction": direction_factory(),
		"movement": movement_factory()
	}
