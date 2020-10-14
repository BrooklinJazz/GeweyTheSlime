extends Node

const SPEED = 100 * 50

class_name WallMovement

var character
func _init(parent):
	character = parent

func main(delta):
	print(Player.motion)
	print(Player.state.direction)

	
	if character.rotation_degrees != 90 * reverse_multiplier():
		print(character.rotation_degrees)
		character.rotation_degrees = 90 * reverse_multiplier()
		character.global_position += Vector2(-7, 0) * reverse_multiplier()
	climb(delta)
	character.move_and_slide(Player.motion, Vector2.UP)

func climb(delta):
	print("Climb")
	Player.motion.y = 0
	if (Player.state.direction == Enums.Direction.LEFT):
		print("LEFT")
		Player.motion.y = -SPEED * delta * reverse_multiplier()
	elif (Player.state.direction == Enums.Direction.RIGHT):
		print("RIGHT")
		Player.motion.y = SPEED * delta * reverse_multiplier()
	else:
		print("????")

func reverse_multiplier():
	for i in range(character.get_slide_count()):
		var collision = character.get_slide_collision(i)
		if collision.normal.x > 0:
			return 1
		elif collision.normal.x < 0:
			return -1
	return 1
