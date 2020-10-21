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
	self.update_player_motion(delta)
	Animate.main()

func update_player_motion(delta: float):
	Player.motion = Physics.get_motion(delta)
	move_and_slide(Player.motion, Vector2.UP)
