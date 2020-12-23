extends KinematicBody2D

var Animations	
var Physics
var StateMachine


onready var collision = get_node("Collision")

onready var sprite = get_node("Sprites")

onready var left_ray = get_node("LeftRay")
onready var right_ray = get_node("RightRay")
onready var down_ray = get_node("DownRay")
onready var up_ray = get_node("UpRay")

func rotate_down():
	self.rotation_degrees = 0
	left_ray = get_node("LeftRay")
	right_ray = get_node("RightRay")
	down_ray = get_node("DownRay")
	up_ray = get_node("UpRay")

func rotate_up():
	self.rotation_degrees = 180
	left_ray = get_node("RightRay")
	right_ray = get_node("LeftRay")
	down_ray = get_node("UpRay")
	up_ray = get_node("DownRay")

func rotate_left():
	self.rotation_degrees = 90
	left_ray = get_node("DownRay")
	right_ray = get_node("UpRay")
	down_ray = get_node("RightRay")
	up_ray = get_node("LeftRay")

func rotate_right():
	self.rotation_degrees = -90
	left_ray = get_node("UpRay")
	right_ray = get_node("DownRay")
	down_ray = get_node("LeftRay")
	up_ray = get_node("RightRay")

func on_ceiling():
	return up_ray.is_colliding()
	
func on_right_wall():
	return right_ray.is_colliding()
	
func on_floor():
	return down_ray.is_colliding()
	
func on_left_wall():
	return left_ray.is_colliding()

func _ready():
	Animations = PlayerAnimate.new($Sprites/Body, $Sprites/Legs)
	StateMachine = PlayerStateMachine.new()

func _physics_process(delta):
	print({
		"on_ceiling": on_ceiling(),
		"on_left_wall": on_left_wall(),
		"on_right_wall": on_right_wall(),
		"on_floor": on_floor()
	})
	StateMachine.run(self, delta)
#	self.update_player_motion(delta)
#	self.update_player_animations()

#func update_player_motion(delta: float):
##	Player.motion = move_and_slide(Physics.get_motion(delta), Vector2.UP)
#
#
#func update_player_animations():
#	Animations.animate()
