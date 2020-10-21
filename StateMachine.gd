extends Node


# Called when the node enters the scene tree for the first time.
class_name PlayerStateMachine

var character
func _init(parent):
	character = parent
	
func main():
	Player.state = {
		"airborn": airborn_factory(),
		"direction": direction_factory(),
		"movement": movement_factory()
	}
	
func direction_factory():
	if (Input.is_action_pressed("right") and Input.is_action_pressed("left")):
		return Enums.Direction.CENTER
	elif (Input.is_action_pressed("left")):
		return Enums.Direction.LEFT
	elif (Input.is_action_pressed("right")):
		return Enums.Direction.RIGHT
	else:
		return Enums.Direction.CENTER

func movement_factory():
	if (Input.is_action_pressed("jump")):
		return Enums.Movement.JUMP_CHARGE
	elif (Input.is_action_pressed("grip")):
		return Enums.Movement.GRIP
	else:
		return Enums.Movement.WALK
		
func airborn_factory():
#	TODO - expand this factory to introduce all states
	if (Input.is_action_just_released("jump") and self.character.is_on_floor()):
		return Enums.Airborn.JUMPED
	elif (self.character.is_on_ceiling()):
		return Enums.Airborn.ON_CEILING
	
	# TODO - touching both at once causes fast switching between states
	elif (self.character.is_on_floor()):
		return Enums.Airborn.ON_FLOOR
	elif (self.character.is_on_wall()):
		return Enums.Airborn.ON_WALL
	else:
		return Enums.Airborn.IDLE
