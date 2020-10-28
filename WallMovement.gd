extends Node

const SPEED = 100

class_name WallMovement

var character
func _init(parent):
	character = parent

func get_motion(delta: float) -> Vector2:
	if character.rotation_degrees != 90 * reverse_multiplier():
		character.rotation_degrees = 90 * reverse_multiplier()
		character.global_position += Vector2(-7, 0) * reverse_multiplier()
	return Vector2(Player.motion.x, climb())


func climb() -> float:
	var motion = 0.0
	if (Player.state.direction.y == Enums.Direction.UP):
		motion = -SPEED
	elif (Player.state.direction.y == Enums.Direction.DOWN):
		motion = SPEED
	return motion

func reverse_multiplier() -> int:
	for i in range(self.character.get_slide_count()):
		var collision = self.character.get_slide_collision(i)
		if collision.normal.x > 0:
			return 1
		elif collision.normal.x < 0:
			return -1
	return 1
