extends Node

const SPEED = 100 * 50

class_name CeilingMovement

var character
func _init(parent):
	character = parent

func main(delta):
	if character.rotation_degrees != 180:
		character.rotation_degrees = 180
		character.global_position += Vector2(0, -2)
	climb(delta)

func climb(delta):
	Player.motion.y = -1
	if (Player.state.direction == Enums.Direction.LEFT):
		Player.motion.x = -SPEED * delta
	elif (Player.state.direction == Enums.Direction.RIGHT):
		Player.motion.x = SPEED * delta
	else:
		Player.motion.x = 0

