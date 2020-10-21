extends Node

const SPEED = 100 * 50



class_name WallMovement

var character
func _init(parent):
	character = parent

func main(delta):
	if character.rotation_degrees != 90 * reverse_multiplier():
		character.rotation_degrees = 90 * reverse_multiplier()
		character.global_position += Vector2(-7, 0) * reverse_multiplier()
	climb(delta)


func climb(delta):
	Player.motion.y = 0
	if (Player.state.direction == Enums.Direction.LEFT):
		Player.motion.y = -SPEED * delta * self.reverse_multiplier()
	elif (Player.state.direction == Enums.Direction.RIGHT):
		Player.motion.y = SPEED * delta * self.reverse_multiplier()

func reverse_multiplier():
	for i in range(self.character.get_slide_count()):
		var collision = self.character.get_slide_collision(i)
		if collision.normal.x > 0:
			return 1
		elif collision.normal.x < 0:
			return -1
	return 1
