extends Node


# Called when the node enters the scene tree for the first time.
class_name PlayerStateMachine

var character
func _init(parent):
	character = parent
	
func main():
	PlayerVariables.state = {
		"airborn": airborn_factory(),
		"direction": direction_factory(),
		"movement": movement_factory()
	}
	
func direction_factory():
	if (Input.is_action_pressed("right") and Input.is_action_pressed("left")):
		return PlayerVariables.Direction.CENTER
	elif (Input.is_action_pressed("left")):
		return PlayerVariables.Direction.LEFT
	elif (Input.is_action_pressed("right")):
		return PlayerVariables.Direction.RIGHT
	else:
		return PlayerVariables.Direction.CENTER

func movement_factory():
	if (Input.is_action_pressed("jump")):
		return PlayerVariables.Movement.JUMP_CHARGE
	elif (Input.is_action_pressed("grip")):
		return PlayerVariables.Movement.GRIP
	else:
		return PlayerVariables.Movement.WALK
		
func airborn_factory():
#	TODO - expand this factory to introduce all states
	if (Input.is_action_just_released("jump") and self.character.is_on_floor()):
		return PlayerVariables.Airborn.JUMPED
	elif (self.character.is_on_floor()):
		return PlayerVariables.Airborn.ON_FLOOR
	elif (self.character.is_on_ceiling()):
		return PlayerVariables.Airborn.ON_CEILING
	else:
		return PlayerVariables.Airborn.IDLE
