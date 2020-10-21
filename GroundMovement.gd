extends Node

#const SPEED = 10
#const ACCELERATION = 50
const GRIP_SPEED = 200
const WALK_SPEED = 400
const GRAVITY = 400
const JUMP_FORCE = 1000 * 15

class_name GroundMovement

var character
func _init(parent):
	character = parent
	
func main(delta):
	if character.rotation_degrees != 0:
		character.rotation_degrees = 0
		character.global_position += Vector2(0,7)
	Player.motion.y = gravity(delta)
	Player.motion.x = walk(delta)
	jump(delta)

	
func get_speed():
	if (Player.state.movement == Enums.Movement.GRIP):
		return GRIP_SPEED
	else:
		return WALK_SPEED

func walk(delta):
	var motion = Player.motion.x
	var speed = get_speed()
	match Player.state.direction:
		Enums.Direction.LEFT:
			motion += (-speed * delta)
		Enums.Direction.RIGHT:
			motion += (speed * delta)
		_:
			motion *= 0.95
	return motion * 0.97

#		Current speed
#		Top speed
#		Accel

		
func gravity(delta):
	if (Player.state.airborn == Enums.Airborn.ON_FLOOR):
		return 0
	else:
		return Player.motion.y + (GRAVITY * delta)

func jump(delta):
	if (Player.state.airborn == Enums.Airborn.JUMPED):
		Player.motion.y -= JUMP_FORCE * delta 
