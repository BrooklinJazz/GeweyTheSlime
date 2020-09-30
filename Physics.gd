extends Node


var Direction = load("./StateEnums.gd").Direction
var Movement = load("./StateEnums.gd").Movement
var Airborn = load("./StateEnums.gd").Airborn

const SPEED = 100
const GRIP_SPEED = 100 * 50
const WALK_SPEED = 200 * 50
const GRAVITY = 400
const JUMP_FORCE = 1000 * 15
var motion = Vector2()

class_name PlayerPhysics

func get_speed(movement):
	if (movement == Movement.GRIP):
		return GRIP_SPEED
	else:
		return WALK_SPEED

func walk(state, delta):
	var speed = get_speed(state.movement)
	if (state.direction == Direction.LEFT):
		motion.x = -speed * delta
	elif (state.direction == Direction.RIGHT):
		motion.x = speed * delta
	else:
		motion.x = 0
		
func gravity(state, delta):
	if (state.airborn == Airborn.ON_FLOOR):
		motion.y = 0
	else:
		motion.y += GRAVITY * delta
func jump(state, delta):
	if (state.airborn == Airborn.JUMPED):
		motion.y -= JUMP_FORCE * delta

func main(state, delta):
	walk(state, delta)
	gravity(state, delta)
	jump(state, delta)
	return motion
	
