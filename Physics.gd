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
	# TODO - return motion instead
	movement.main(delta)
	var motion = Player.motion #+ Hook.motion
	self.character.move_and_slide(motion, Vector2.UP)
	
