extends KinematicBody2D

export(float) var airExternalFactor = 1.1
export(float) var gripExternalFactor = 0.4
export(float) var groundExternalFactor = 0.9

var Animations	
var Physics
var StateMachine

func _ready():
	Animations = PlayerAnimate.new($Sprites/Body, $Sprites/Legs)
	Physics = PlayerPhysics.new(self)
	StateMachine = PlayerStateMachine.new(self)

func _physics_process(delta):
	self.update_player_state()
	self.update_player_motion(delta)
	self.update_player_animations()

func update_player_state():
	Player.state = StateMachine.get_state()

func update_player_motion(delta: float):
	Player.motion = move_and_slide(Physics.get_motion(delta), Vector2.UP)

func update_player_animations():
	Animations.animate()

func external_force(force: Vector2):
	#if "airborne":
	Player.motion += airExternalFactor*force
	#elif "gripped":
	#	Player.motion += gripExternalFactor*force
	#else:
	#	Player.motion += Vector2(groundExternalFactor*force.x, force.y)
