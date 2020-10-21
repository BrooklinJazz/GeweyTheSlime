extends Node

const SPEED = 5000

class_name CeilingMovement

var character
func _init(parent):
	character = parent

func get_motion(delta: float) -> Vector2:
	if character.rotation_degrees != 180:
		character.rotation_degrees = 180
		character.global_position += Vector2(0, -2)
	return Vector2(climb(delta), -1)

func climb(delta: float) -> float:
	if (Player.state.direction == Enums.Direction.LEFT):
		return -SPEED * delta
	elif (Player.state.direction == Enums.Direction.RIGHT):
		return SPEED * delta
	return 0.0

