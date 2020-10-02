extends KinematicBody2D

var Animate	
var Physics
var StateMachine

func _ready():
	Animate = PlayerAnimate.new($Sprites/Body, $Sprites/Legs, $Sprites)
	Physics = PlayerPhysics.new(self)
	StateMachine = PlayerStateMachine.new(self)

func _physics_process(delta):
	StateMachine.main()
	Physics.main(delta)
	Animate.main()
