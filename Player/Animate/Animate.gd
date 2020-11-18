extends Node

class_name PlayerAnimate

var body
var legs

func _init(Body, Legs):
	body = Body
	legs = Legs
	
func animate() -> Vector2:
	return animate_factory().animate()

func animate_factory() -> Node:
	if (Player.state.airborne.on_wall and Player.state.movement.grip):
		print("wall")
		return WallAnimate.new(self.body, self.legs)
	print("ground")
	return GroundAnimate.new(self.body, self.legs)

#	if (Player.state.airborne.on_ceiling and Player.state.movement.grip):
#		return CeilingMovement.new(self.character)
#	elif (Player.state.airborne.on_wall and Player.state.movement.grip):
#		return WallMovement.new(self.character)
#	else:
#		return GroundMovement.new(self.character)
