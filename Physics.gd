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
	
func get_speed():
	if (Player.state.movement == Enums.Movement.GRIP):
		return GRIP_SPEED
	else:
		return WALK_SPEED

func walk(delta):
	var speed = get_speed()
	if (Player.state.direction == Enums.Direction.LEFT):
		Player.motion.x = -speed * delta
	elif (Player.state.direction == Enums.Direction.RIGHT):
		Player.motion.x = speed * delta
	else:
		Player.motion.x = 0
		
func gravity(delta):
	if (Player.state.airborn == Enums.Airborn.ON_FLOOR):
		Player.motion.y = 0
	else:
		Player.motion.y += GRAVITY * delta

func jump(delta):
	if (Player.state.airborn == Enums.Airborn.JUMPED):
		Player.motion.y -= JUMP_FORCE * delta

func main(delta):
	gravity(delta)
	walk(delta)
	jump(delta)
	self.character.move_and_slide(Player.motion, Vector2.UP)

