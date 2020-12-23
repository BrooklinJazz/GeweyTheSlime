extends KinematicBody2D

var Animations	
var Physics
var StateMachine

func _ready():
	Animations = PlayerAnimate.new($Sprites/Body, $Sprites/Legs)
	StateMachine = PlayerStateMachine.new()

func _physics_process(delta):
	StateMachine.run(self, delta)
#	self.update_player_motion(delta)
#	self.update_player_animations()

#func update_player_motion(delta: float):
##	Player.motion = move_and_slide(Physics.get_motion(delta), Vector2.UP)
#
#
#func update_player_animations():
#	Animations.animate()
