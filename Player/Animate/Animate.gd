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
		return WallAnimate.new(self.body, self.legs)
	return GroundAnimate.new(self.body, self.legs)
