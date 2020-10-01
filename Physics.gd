extends Node

func movement_factory(character):
	if (Player.state.airborn == Enums.Airborn.ON_CEILING and Player.state.movement == Enums.Movement.GRIP):
		return CeilingMovement.new(character)
	elif (Player.state.airborn == Enums.Airborn.ON_WALL and Player.state.movement == Enums.Movement.GRIP):
		return WallMovement.new(character)
	else:
		return GroundMovement.new(character)

class_name PlayerPhysics

var character
func _init(parent):
	character = parent

func main(delta):
	var movement = movement_factory(self.character)
	movement.main(delta)
