extends KinematicBody2D

var Direction = load("./StateEnums.gd").Direction
var Movement = load("./StateEnums.gd").Movement
var Airborn = load("./StateEnums.gd").Airborn

var Animator = PlayerAnimator.new()		
var Physics = PlayerPhysics.new()

func _process(delta):
	var state = PlayerStateMachine.new(self).create()
	var motion = Physics.main(state, delta)
	move_and_slide(motion, Vector2.UP)
	Animator.animate(state, $Body, $Legs)

