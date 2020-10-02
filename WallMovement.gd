extends Node

const SPEED = 100 * 50



class_name WallMovement

var character
func _init(parent):
	character = parent

func main(delta):
	self.character.rotation_degrees = 270 * self.reverse_multiplier()
	climb(delta)
	self.character.move_and_slide(Player.motion, Vector2.UP)

func climb(delta):
	Player.motion.y = 0
	if (Player.state.direction == Enums.Direction.LEFT):
		Player.motion.y = SPEED * delta * self.reverse_multiplier()
	elif (Player.state.direction == Enums.Direction.RIGHT):
		Player.motion.y = -SPEED * delta * self.reverse_multiplier()

func reverse_multiplier():
	for i in range(self.character.get_slide_count()):
		var collision = self.character.get_slide_collision(i)
		if collision.normal.x > 0:
			return -1
		elif collision.normal.x < 0:
			return 1
	return 1
