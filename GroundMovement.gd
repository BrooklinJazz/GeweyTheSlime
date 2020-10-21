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
	gravity(delta)
	walk(delta)
	jump(delta)

	
func get_speed():
	if (Player.state.movement == Enums.Movement.GRIP):
		return GRIP_SPEED
	else:
		return WALK_SPEED

func walk(delta):
	var speed = get_speed()
	if (Player.state.direction == Enums.Direction.LEFT):
		Player.motion.x += -speed * delta
		
	elif (Player.state.direction == Enums.Direction.RIGHT):
		Player.motion.x += speed * delta
	else:
		Player.motion.x *= 0.95
	Player.motion.x *= 0.97

#		Current speed
#		Top speed
#		Accel

		
func gravity(delta):
	if (Player.state.airborn == Enums.Airborn.ON_FLOOR):
		Player.motion.y = 0
	else:
		Player.motion.y += GRAVITY * delta

func jump(delta):
	if (Player.state.airborn == Enums.Airborn.JUMPED):
		Player.motion.y -= JUMP_FORCE * delta 
