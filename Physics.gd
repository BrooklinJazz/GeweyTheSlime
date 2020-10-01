extends Node

class_name PlayerPhysics

var movement
func _init(character):
	movement = GroundMovement.new(character)

func main(delta):
	self.movement.main(delta)
