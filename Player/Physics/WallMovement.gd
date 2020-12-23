extends Node

const ACCELERATION = 200

class_name WallMovement

var character
func _init(parent):
	character = parent

func get_motion(delta: float):
	if Player.state.airborne.on_wall_right:
		return Vector2(-1, climb(delta))

	if Player.state.airborne.on_wall_left:
		return Vector2(1, climb(delta))

func climb(delta:float) -> float:
	var motion = Player.motion.y
	if (Player.state.direction.y.up):
		motion += -ACCELERATION  * delta
	elif (Player.state.direction.y.down):
		motion += ACCELERATION  * delta
	else:
		motion *= 0.95
	return motion * 0.97
