extends KinematicBody2D

var Animate	
var Physics
var StateMachine

func _ready():
	Animate = PlayerAnimate.new($Body, $Legs)
	Physics = PlayerPhysics.new(self)
	StateMachine = PlayerStateMachine.new(self)

func _process(delta):
	StateMachine.main()
	Physics.main(delta)
	Animate.main()
