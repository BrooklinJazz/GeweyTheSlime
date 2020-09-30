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

const SPEED = 100

var movement = Movement.WALK
var direction = Direction.CENTER
var airborn = Airborn.FALLING
var motion = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func direction_factory():
	if (Input.is_action_pressed("right") and Input.is_action_pressed("left")):
		return Direction.CENTER
	elif (Input.is_action_pressed("left")):
		return Direction.LEFT
	elif (Input.is_action_pressed("right")):
		return Direction.RIGHT
	else:
		return Direction.CENTER

func movement_factory():
	if (Input.is_action_pressed("jump")):
		return Movement.JUMP_CHARGE
	elif (Input.is_action_pressed("grip")):
		return Movement.GRIP
	else:
		return Movement.WALK
		
func airborn_factory():
#	TODO - expand this factory to introduce all states
	if (Input.is_action_just_released("jump") and is_on_floor()):
		return Airborn.JUMPED
	elif (is_on_floor()):
		return Airborn.ON_FLOOR
	elif (is_on_ceiling()):
		return Airborn.ON_CEILING
	else:
		return Airborn.IDLE
	
func state_factory():
	return {
		"airborn": airborn_factory(),
		"direction": direction_factory(),
		"movement": movement_factory()
	}

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

func _process(delta):
	var state = state_factory()
	walk(state, delta)
	gravity(state, delta)
	jump(state, delta)
	move_and_slide(motion, Vector2.UP)
	animate(state)
	
func jump(state, delta):
	if (state.airborn == Airborn.JUMPED):
		motion.y -= JUMP_FORCE * delta

func animate(state):
	if (state.direction == Direction.LEFT):
		$Body.flip_h = true
	elif (state.direction == Direction.RIGHT):
		$Body.flip_h = false
	match state.movement:
		Movement.WALK:
			$Body.set_animation("default")
			$Legs.set_animation("walk")
			pass
		Movement.GRIP:
			$Body.set_animation("grip")
			$Legs.set_animation("grip")
		Movement.JUMP_CHARGE:
			$Legs.play("charge_jump")
			$Body.play("charge_jump")
			return
#	set animation defaults to start playing for some reason
	$Legs.stop()	
#	TODO - we probably have to make this work with delta to make frames match movement
	var numberOfFrames = $Legs.get_sprite_frames().get_frame_count($Legs.get_animation())
	match state.direction:
		Direction.CENTER:
			pass
		Direction.LEFT:
			#	TODO - figure out how to improve logic
			if ($Legs.get_frame() == 0):
				$Legs.set_frame(7)
			else:
				$Legs.set_frame(($Legs.get_frame() - 1))		
		Direction.RIGHT:
			$Legs.set_frame(($Legs.get_frame() + 1) % numberOfFrames)
