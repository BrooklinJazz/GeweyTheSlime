extends KinematicBody2D

var Animator = PlayerAnimator.new()		
var Physics = PlayerPhysics.new(self)
var StateMachine = PlayerStateMachine.new(self)

func _process(delta):
	StateMachine.main()
	Physics.main(delta)
	Animator.main($Body, $Legs)

