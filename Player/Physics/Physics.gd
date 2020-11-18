extends Node

class_name PlayerPhysics

var character
func _init(parent):
	character = parent

func get_motion(delta: float) -> Vector2:
	return movement_factory().get_motion(delta)

func movement_factory() -> Node:
	if (Player.state.airborne.on_ceiling and Player.state.movement.grip):
		return CeilingMovement.new(self.character)
	elif (Player.state.airborne.on_wall and Player.state.movement.grip):
		return WallMovement.new(self.character)
	else:
		return GroundMovement.new(self.character)
