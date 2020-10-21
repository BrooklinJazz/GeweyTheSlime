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

enum Airborne {
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
	"airborne": Airborne.FALLING
}

var motion = Vector2()
