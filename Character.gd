extends KinematicBody2D

var Animator = PlayerAnimator.new()		
var Physics = PlayerPhysics.new(self)

func _process(delta):
	PlayerStateMachine.new(self).create()
	Physics.main(delta)
	Animator.animate($Body, $Legs)

