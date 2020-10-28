extends Node

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	CENTER,
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
