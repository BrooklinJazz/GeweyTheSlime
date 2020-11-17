extends Node

const ACCELERATION = 200

class_name CeilingMovement

var character
func _init(parent):
	character = parent

func get_motion(delta: float) -> Vector2:
	if abs(character.rotation_degrees) < 179 or abs(character.rotation_degrees) > 181:
		print(character.rotation_degrees)
		character.rotation_degrees = 180
		character.global_position += Vector2(0, -8)

	return Vector2(climb(delta), -1)

func climb(delta: float) -> float:
	var motion = Player.motion.x
	if (Player.state.direction.x.left):
		motion += (-ACCELERATION * delta)
	elif Player.state.direction.x.right:
		motion += (ACCELERATION * delta)
	else:
		motion *= 0.95
	return motion * 0.97
	

