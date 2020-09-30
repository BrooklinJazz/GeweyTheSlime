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
	if (movement == Enums.Movement.GRIP):
		return GRIP_SPEED
	else:
		return WALK_SPEED

func walk(state, delta):
	var speed = get_speed(state.movement)
	if (state.direction == Enums.Direction.LEFT):
		Player.motion.x = -speed * delta
	elif (state.direction == Enums.Direction.RIGHT):
		Player.motion.x = speed * delta
	else:
		Player.motion.x = 0
		
func gravity(state, delta):
	if (state.airborn == Enums.Airborn.ON_FLOOR):
		Player.motion.y = 0
	else:
		Player.motion.y += GRAVITY * delta
func jump(state, delta):
	if (state.airborn == Enums.Airborn.JUMPED):
		Player.motion.y -= JUMP_FORCE * delta

func main(delta):
	walk(Player.state, delta)
	gravity(Player.state, delta)
	jump(Player.state, delta)
	self.character.move_and_slide(Player.motion, Vector2.UP)

