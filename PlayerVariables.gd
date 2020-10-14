extends Node

enum Direction {
	LEFT,
	RIGHT,
	CENTER
}

enum Movement {
	WALK,
	GRIP,
	JUMP_CHARGE
}

enum Airborn {
	RISING,
	FALLING,
	ON_FLOOR,
	ON_CEILING,
	JUMPED,
	ON_WALL,
	IDLE
}

export var state = {
	"movement": Movement.WALK,
	"direction": Direction.CENTER,
	"airborn": Airborn.FALLING
}

var motion = Vector2()
