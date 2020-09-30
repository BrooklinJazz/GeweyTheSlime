extends KinematicBody2D

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

var motion = Vector2()

const SPEED = 100
const GRIP_SPEED = 100 * 50
const WALK_SPEED = 200 * 50
const GRAVITY = 400
const JUMP_FORCE = 1000 * 15

func get_speed(movement):
	if (movement == Movement.GRIP):
		return GRIP_SPEED
	else:
		return WALK_SPEED

func walk(state, delta):
	var speed = get_speed(state.movement)
	if (state.direction == Direction.LEFT):
		motion.x = -speed * delta
	elif (state.direction == Direction.RIGHT):
		motion.x = speed * delta
	else:
		motion.x = 0
		
func gravity(state, delta):
	if (state.airborn == Airborn.ON_FLOOR):
		motion.y = 0
	else:
		motion.y += GRAVITY * delta
		
var Animator = PlayerAnimator.new()		

func _process(delta):
	var state = PlayerStateMachine.new(self).create()
	walk(state, delta)
	gravity(state, delta)
	jump(state, delta)
	move_and_slide(motion, Vector2.UP)
	Animator.animate(state, $Body, $Legs)
	
func jump(state, delta):
	if (state.airborn == Airborn.JUMPED):
		motion.y -= JUMP_FORCE * delta
