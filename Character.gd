extends KinematicBody2D
class_name StateMachine

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func direction_factory():
	if (Input.is_action_pressed("right") and Input.is_action_pressed("left")):
		return  Direction.CENTER
	elif (Input.is_action_pressed("left")):
		return Direction.LEFT
	elif (Input.is_action_pressed("right")):
		return Direction.RIGHT

func movement_factory():
	if (Input.is_action_pressed("jump")):
		return Movement.JUMP_CHARGE
	elif (Input.is_action_pressed("grip")):
		return Movement.GRIP
	else:
		return Movement.WALK
		
func airborn_factory():
	if (is_on_floor()):
		return Airborn.ON_FLOOR
	elif (is_on_ceiling()):
		return Airborn.ON_CEILING
	else:
		return Airborn.IDLE
	
func state_factory():
	return {
		"airborn": airborn_factory(),
		"direction":direction_factory(),
		"movement": movement_factory()
	}

const GRIP_SPEED = 100
const WALK_SPEED = 200	

func get_speed(movement):
	if (movement == Movement.GRIP):
		return GRIP_SPEED
	else:
		return WALK_SPEED

func walk(state, delta):
	var speed = get_speed(state.movement)
	if (state.direction == Direction.LEFT):
		motion.x = speed * delta
	elif (state.direction == Direction.RIGHT):
		motion.x = -speed * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var state = state_factory()
	walk(state, delta)
	move_and_slide(motion, Vector2.UP)
#	animate()
	
func animate():
	if (Input.is_action_pressed("jump")):
		$Legs.play("charge_jump")
		$Body.play("charge_jump")
	elif (Input.is_action_pressed("grip") and Input.is_action_pressed("right")):
		$Legs.play("grip")
		$Body.play("grip")
	elif (Input.is_action_pressed("grip") and Input.is_action_pressed("left")):
		$Legs.play("grip", true)
		$Body.play("grip")
	elif ($Legs.animation == "walk" or $Legs.animation == "grip") and $Legs.frame != 0:
		print($Legs.frame)
		pass
	elif (Input.is_action_pressed("grip")):
		$Legs.play("grip_idle")
		$Body.play("grip")
	elif (Input.is_action_pressed("right")):
		$Legs.play("walk")
		$Body.play("idle")
	elif (Input.is_action_pressed("left")):
		$Legs.play("walk", true)
		$Body.play("idle")
	else:
		$Body.play("idle")
		$Legs.play("idle")
