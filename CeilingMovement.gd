extends Node

const SPEED = 100 * 50

class_name CeilingMovement

var character
func _init(parent):
	character = parent

func main(delta):
	climb(delta)
	self.character.move_and_slide(Player.motion, Vector2.UP)

func climb(delta):
	Player.motion.y = -1
	if (Player.state.direction == Enums.Direction.LEFT):
		Player.motion.x = -SPEED * delta
	elif (Player.state.direction == Enums.Direction.RIGHT):
		Player.motion.x = SPEED * delta
	else:
		Player.motion.x = 0
