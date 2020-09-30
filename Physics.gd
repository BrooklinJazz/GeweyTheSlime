extends Node

const SPEED = 100
const GRIP_SPEED = 100 * 50
const WALK_SPEED = 200 * 50
const GRAVITY = 400
const JUMP_FORCE = 1000 * 15

class_name PlayerPhysics

var character
func _init(parent):
	character = parent
	
func get_speed(movement):
	if (movement == PlayerVariables.Movement.GRIP):
		return GRIP_SPEED
	else:
		return WALK_SPEED

func walk(state, delta):
	var speed = get_speed(state.movement)
	if (state.direction == PlayerVariables.Direction.LEFT):
		PlayerVariables.motion.x = -speed * delta
	elif (state.direction == PlayerVariables.Direction.RIGHT):
		PlayerVariables.motion.x = speed * delta
	else:
		PlayerVariables.motion.x = 0
		
func gravity(state, delta):
	if (state.airborn == PlayerVariables.Airborn.ON_FLOOR):
		PlayerVariables.motion.y = 0
	else:
		PlayerVariables.motion.y += GRAVITY * delta
func jump(state, delta):
	if (state.airborn == PlayerVariables.Airborn.JUMPED):
		PlayerVariables.motion.y -= JUMP_FORCE * delta

func main(delta):
	walk(PlayerVariables.state, delta)
	gravity(PlayerVariables.state, delta)
	jump(PlayerVariables.state, delta)
	self.character.move_and_slide(PlayerVariables.motion, Vector2.UP)

