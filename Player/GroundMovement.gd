extends Node

#const SPEED = 10
#const ACCELERATION = 50
const GRIP_SPEED = 200
const WALK_SPEED = 400
const GRAVITY = 400
const JUMP_FORCE = -250.0

class_name GroundMovement

var character
func _init(parent):
	character = parent
	
func get_motion(delta: float) -> Vector2:
	# TODO: Move this character elsewhere (class should not be responsible)
	if character.rotation_degrees != 0:
		character.rotation_degrees = 0
		character.global_position += Vector2(0, 7)
	
	# if on wall and input is up or into wall
		# transition
	# if character.is_on_wall() and Player.state.direction.y.up:
		
		
	return Vector2(walk(delta), jump(delta))


func get_speed() -> int:
	if (Player.state.movement.grip):
		return GRIP_SPEED
	return WALK_SPEED

func walk(delta: float) -> float:
	var speed = get_speed()
	var motion = Player.motion.x
	if (Player.state.direction.x.left):
		motion += (-speed * delta)
	elif Player.state.direction.x.right:
		motion += (speed * delta)
	else:
		motion *= 0.95
	return motion * 0.97

func jump(delta: float) -> float:
	if (Player.state.airborne.jumped):
		return JUMP_FORCE
	if (Player.state.airborne.on_floor):
		return Player.motion.y
	return Player.motion.y + (GRAVITY * delta)
