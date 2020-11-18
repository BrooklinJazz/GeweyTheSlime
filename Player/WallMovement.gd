extends Node

const ACCELERATION = 200

class_name WallMovement

var character
func _init(parent):
	character = parent

func get_motion(delta: float) -> Vector2:
	if character.rotation_degrees != 90 * reverse_multiplier():
		character.rotation_degrees = 90 * reverse_multiplier()
		character.global_position += Vector2(-7, 0) * reverse_multiplier()
	return Vector2(-reverse_multiplier(), climb(delta))

func climb(delta:float) -> float:
	print(Player.motion.y, Player.motion.x)
	var motion = Player.motion.y - abs(Player.motion.x) 
	if (Player.state.direction.y.up):
		motion += -ACCELERATION  * delta
	elif (Player.state.direction.y.down):
		motion += ACCELERATION  * delta
	else:
		motion *= 0.95
	return motion * 0.97

func reverse_multiplier() -> int:
	for i in range(self.character.get_slide_count()):
		var collision = self.character.get_slide_collision(i)
		if collision.normal.x > 0:
			return 1
		elif collision.normal.x < 0:
			return -1
	return 1
