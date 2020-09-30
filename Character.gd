extends KinematicBody2D

var Animate = PlayerAnimate.new()		
var Physics = PlayerPhysics.new(self)
var StateMachine = PlayerStateMachine.new(self)

func _process(delta):
	StateMachine.main()
	Physics.main(delta)
	Animate.main($Body, $Legs)
