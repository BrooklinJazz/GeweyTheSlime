extends Node


func StateMachineAdapter(current_state):
	var jumped = false
	var on_ceiling = false
	var on_floor = false
	var on_wall = false
	var idle = false
	var on_wall_left = false
	var on_wall_right = false
	if (current_state == States.GROUND):
		on_floor = true
	elif (current_state == States.JUMPED):
		jumped = true
	elif (current_state == States.Grabbed.LEFT_WALL):
		on_wall = true
		on_wall_right = true # obviously wrong and needs to be changed but works
	elif (current_state == States.Grabbed.RIGHT_WALL):
		on_wall = true
		on_wall_left = true # obviously wrong and needs to be changed but works
	elif (current_state == States.Grabbed.CEILING):
		on_ceiling = true
	return {
			"jumped": jumped,
			"on_ceiling": on_ceiling,
			"on_floor": on_floor,
			"on_wall": on_wall,
			"idle": idle,
			"on_wall_left": on_wall_left,
			"on_wall_right": on_wall_right,
		}
		

class State:
	func get_event(character):
		pass
	func on_exit(event, character):
		pass
	func on_enter(character):
		pass
	

class GroundState extends State:
	func get_event(character):
		if (Input.is_action_just_released("jump")):
			return Events.JUMP
		elif (Input.is_action_pressed("grip")):
			return Events.ATTACH_TO_FLOOR

class CeilingState extends State:
	func get_event(character):
		if (!Input.is_action_pressed("grip")):
			return Events.RELEASE
		elif (!character.is_on_ceiling()):
			return Events.RELEASE
		elif (character.is_on_wall() and Input.is_action_pressed("right")):
			return Events.ATTACH_TO_RIGHT_WALL
		elif (character.is_on_wall() and Input.is_action_pressed("left")):
			return Events.ATTACH_TO_LEFT_WALL
			
	func on_enter(character):
		character.rotation_degrees = 180
		character.global_position += Vector2(0, -9)

class GrabbedFloorState extends State:
	func get_event(character):
		if (character.is_on_wall() and Input.is_action_pressed("left")):
			return Events.ATTACH_TO_LEFT_WALL
		elif (character.is_on_wall() and Input.is_action_pressed("right")):
			return Events.ATTACH_TO_RIGHT_WALL
		elif (Input.is_action_just_released("grip")):
			return Events.RELEASE

class JumpState extends State:
	func get_event(character):
		return Events.FALL
			
class RightWallState extends State:
	func get_event(character):
		if (character.is_on_ceiling() and Input.is_action_pressed("up")):
			return Events.ATTACH_TO_CEILING
		elif (!character.is_on_wall()):
			return Events.RELEASE
		if (!Input.is_action_pressed("grip")):
			return Events.RELEASE
			
	func on_enter(character):
		character.rotation_degrees = 90
		character.global_position += Vector2(-7, 0)
		
		

class LeftWallState extends State:
	func get_event(character):
		if (character.is_on_ceiling() and Input.is_action_pressed("up")):
			return Events.ATTACH_TO_CEILING
		elif (!character.is_on_wall()):
			return Events.RELEASE
		if (!Input.is_action_pressed("grip")):
			return Events.RELEASE
			
	func on_enter(character):
		character.rotation_degrees = -90
		character.global_position += Vector2(7, 0)


class AirState extends State:
	func get_event(character):
		if (character.is_on_floor()):
			return Events.LAND
		elif (character.is_on_ceiling()):
			return Events.ATTACH_TO_CEILING
		elif (character.is_on_wall() and Input.is_action_pressed("left") and Input.is_action_pressed("grip")):
			return Events.ATTACH_TO_LEFT_WALL
		elif (character.is_on_wall() and Input.is_action_pressed("right") and Input.is_action_pressed("grip")):
			return Events.ATTACH_TO_RIGHT_WALL
		elif (!Input.is_action_pressed("grip")):
			return Events.RELEASE


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



class StateMachine:
	var current_state = States.AIR
	var fsm
	var state_factory = {
		States.AIR: AirState.new(),
		States.JUMPED: JumpState.new(),
		States.GROUND: GroundState.new(),
		States.Grabbed.FLOOR:  GrabbedFloorState.new(),
		States.Grabbed.LEFT_WALL: RightWallState.new(),
		States.Grabbed.RIGHT_WALL: LeftWallState.new(),
		States.Grabbed.CEILING: CeilingState.new()
	}
	func _init(state, machine):
		fsm = machine
		current_state = state
		
	func transition(character):
		var transitions = fsm[current_state]
		var state = state_factory[current_state]
		var event = state.get_event(character)
		if event in transitions:
			state.on_exit(event, character)
			current_state = transitions[event]
			state_factory[current_state].on_enter(character)


class_name PlayerStateMachine
var state_machine
var character


func _init(parent):
	character = parent
	state_machine = StateMachine.new(States.AIR, FSM)
	

func get_state():
	
	state_machine.transition(character)
	return {
		"airborne": StateMachineAdapter(state_machine.current_state),
		"direction": {
			"x": x_direction_factory(),
			"y": y_direction_factory()
		},
		"movement": movement_factory()
	}

func x_direction_factory():
	var right = false
	var center = false
	var left = false
	if (Input.is_action_pressed("right") and Input.is_action_pressed("left")):
		center = true
	elif (Input.is_action_pressed("left")):
		left = true
	elif (Input.is_action_pressed("right")):
		right = true
	else:
		center = true
	return {
		"right": right,
		"center": center,
		"left": left
	}

func y_direction_factory():
	var up = false
	var down = false
	var center = false
	if (Input.is_action_pressed("up") and Input.is_action_pressed("down")):
		center = true
	elif (Input.is_action_pressed("down")):
		down = true
	elif (Input.is_action_pressed("up")):
		up = true
	else:
		center = true
	return {
		"up": up,
		"center": center,
		"down": down
	}

func movement_factory():
	var charge_jump = false
	var grip = false
	var walk = false
	if (Input.is_action_pressed("jump")):
		charge_jump = true
	elif (Input.is_action_pressed("grip")):
		grip = true
	else:
		walk = true

	return {
		"charge_jump": charge_jump,
		"grip": grip,
		"walk": walk
	}
