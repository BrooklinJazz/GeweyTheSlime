extends Node

const GRAVITY = 400
const WALK_SPEED = 400
const JUMP_FORCE = -250.0
const ACCELERATION = 200


class State:
	func get_event(character):
		pass
	func on_exit(character, event):
		pass
	func on_enter(character):
		pass
	func get_motion(delta: float):
		return Vector2(0, 0)

#	TODO extract these

	func walk(delta: float) -> float:
		var motion = Player.motion.x
		if (Input.is_action_pressed("left")):
			motion += (-WALK_SPEED * delta)
		elif (Input.is_action_pressed("right")):
			motion += (WALK_SPEED * delta)
		else:
			motion *= 0.95
		return motion * 0.97
	
	func fall(delta: float) -> float:
		return Player.motion.y + (GRAVITY * delta)
	
	func jump(delta: float) -> float:
		return JUMP_FORCE
	
	func ceiling_climb(delta: float) -> float:
		var motion = Player.motion.x
		if (Input.is_action_pressed("left")):
			motion += (-ACCELERATION * delta)
		elif Input.is_action_pressed("right"):
			motion += (ACCELERATION * delta)
		else:
			motion *= 0.95
		return motion * 0.97
	
	func wall_climb(delta:float) -> float:
		var motion = Player.motion.y
		if (Input.is_action_pressed("up")):
			motion += -ACCELERATION  * delta
		elif (Input.is_action_pressed("down")):
			motion += ACCELERATION  * delta
		else:
			motion *= 0.95
		return motion * 0.97

class GroundState extends State:
	func get_event(character):
		if (Input.is_action_just_released("jump")):
			return Events.JUMP
		elif (Input.is_action_pressed("grip")):
			return Events.ATTACH_TO_FLOOR
			
	func on_enter(character):
		character.rotate_down()
	
	func get_motion(delta: float) -> Vector2:
		return Vector2(walk(delta), 0)

class CeilingState extends State:
	func get_event(character):
		if (!Input.is_action_pressed("grip")):
			return Events.RELEASE
		elif (!character.on_ceiling()):
			return Events.RELEASE
		elif (character.on_right_wall() and Input.is_action_pressed("right")):
			return Events.ATTACH_TO_RIGHT_WALL
		elif (character.on_left_wall() and Input.is_action_pressed("left")):
			return Events.ATTACH_TO_LEFT_WALL
			
	func on_enter(character):
		character.rotate_up()
#		character.global_position += Vector2(0, -1)
		
	func get_motion(delta):
		return Vector2(ceiling_climb(delta), -1)

class GrabbedFloorState extends State:
	func get_event(character):
		if (character.on_left_wall() and Input.is_action_pressed("left")):
			return Events.ATTACH_TO_LEFT_WALL
		elif (character.on_right_wall() and Input.is_action_pressed("right")):
			return Events.ATTACH_TO_RIGHT_WALL
		elif (Input.is_action_just_released("grip")):
			return Events.RELEASE

class JumpState extends State:
	func get_motion(delta):
		return Vector2(walk(delta), jump(delta))
	func get_event(character):
		return Events.FALL
					

class RightWallState extends State:
	func get_event(character):
		if (character.on_ceiling() and Input.is_action_pressed("up")):
			return Events.ATTACH_TO_CEILING
		elif (!character.on_right_wall()):
			return Events.RELEASE
		if (!Input.is_action_pressed("grip")):
			return Events.RELEASE
			
	func on_enter(character):
		character.rotate_right()
#		character.global_position += Vector2(7, 0)
		
#	func on_exit(character, event):
#		if (event == Events.ATTACH_TO_CEILING):
#			character.global_position += Vector2(0, -9)
		
	func get_motion(delta):
		return Vector2(1, wall_climb(delta))
		
class LeftWallState extends State:
	func get_event(character):
		if (character.on_ceiling() and Input.is_action_pressed("up")):
			return Events.ATTACH_TO_CEILING
		elif (!character.on_left_wall()):
			return Events.RELEASE
		if (!Input.is_action_pressed("grip")):
			return Events.RELEASE
			
	func on_enter(character):
		character.rotate_left()
#		character.global_position += Vector2(-7, 0)
		
#	func on_exit(character, event):
#		if (event == Events.ATTACH_TO_CEILING):
#			character.global_position += Vector2(0, -9)
	func get_motion(delta):
		return Vector2(-1, wall_climb(delta))

class AirState extends State:
	func get_motion(delta):
		return Vector2(walk(delta), fall(delta))
		
	func on_enter(character):
		character.rotate_down()
		
	func get_event(character):
		if (character.on_floor()):
			return Events.LAND
		elif (character.on_ceiling() and Input.is_action_pressed("grip")):
			return Events.ATTACH_TO_CEILING
		elif (character.on_left_wall() and Input.is_action_pressed("grip")):
			return Events.ATTACH_TO_LEFT_WALL
		elif (character.on_right_wall() and Input.is_action_pressed("grip")):
			return Events.ATTACH_TO_RIGHT_WALL
		elif (!Input.is_action_pressed("grip")):
			return Events.RELEASE


class_name PlayerStateMachine
var current_state = States.AIR

var FSM = {
	States.AIR: {
		Events.ATTACH_TO_CEILING: States.Grabbed.CEILING,
		Events.ATTACH_TO_FLOOR: States.Grabbed.FLOOR,
		Events.ATTACH_TO_LEFT_WALL: States.Grabbed.LEFT_WALL,
		Events.ATTACH_TO_RIGHT_WALL: States.Grabbed.RIGHT_WALL,
		Events.LAND: States.GROUND
	},
#	bit of a hack to make the StateMachineAdapter work. should remove
	States.JUMPED: {
		Events.FALL: States.AIR
	},
	States.GROUND: {
		Events.FALL: States.AIR,
		Events.JUMP: States.JUMPED,
		Events.ATTACH_TO_FLOOR: States.Grabbed.FLOOR
	},
	States.Grabbed.FLOOR: {
		Events.ATTACH_TO_LEFT_WALL: States.Grabbed.LEFT_WALL,
		Events.ATTACH_TO_RIGHT_WALL: States.Grabbed.RIGHT_WALL,
		Events.RELEASE: States.GROUND
	},
	States.Grabbed.LEFT_WALL: {
		Events.ATTACH_TO_FLOOR: States.Grabbed.FLOOR,
		Events.ATTACH_TO_CEILING: States.Grabbed.CEILING,
		Events.RELEASE: States.AIR
	},
	States.Grabbed.RIGHT_WALL: {
		Events.ATTACH_TO_FLOOR: States.Grabbed.FLOOR,
		Events.ATTACH_TO_CEILING: States.Grabbed.CEILING,
		Events.RELEASE: States.AIR
	},
	States.Grabbed.CEILING: {
		Events.RELEASE: States.AIR,
		Events.ATTACH_TO_LEFT_WALL: States.Grabbed.LEFT_WALL,
		Events.ATTACH_TO_RIGHT_WALL: States.Grabbed.RIGHT_WALL
	}	
}
var state_factory = {
	States.AIR: AirState.new(),
	States.JUMPED: JumpState.new(),
	States.GROUND: GroundState.new(),
	States.Grabbed.FLOOR:  GrabbedFloorState.new(),
	States.Grabbed.LEFT_WALL: LeftWallState.new(),
	States.Grabbed.RIGHT_WALL: RightWallState.new(),
	States.Grabbed.CEILING: CeilingState.new()
}

func run(character,  delta):
	var transitions = FSM[current_state]
	var state = state_factory[current_state]
	var event = state.get_event(character)
#	TODO Extract
	Player.motion = character.move_and_slide(state.get_motion(delta), Vector2.UP)
#	print(current_state)
	if event in transitions:
		print(event)
		state.on_exit(character, event)
		current_state = transitions[event]
#		print(current_state)
		state_factory[current_state].on_enter(character)
