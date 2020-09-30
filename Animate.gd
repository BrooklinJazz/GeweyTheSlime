extends Node

var Direction = load("./StateEnums.gd").Direction
var Movement = load("./StateEnums.gd").Movement
var Airborn = load("./StateEnums.gd").Airborn

class_name PlayerAnimator

func animate(state, Body, Legs):
	if (state.direction == Direction.LEFT):
		Body.flip_h = true
	elif (state.direction == Direction.RIGHT):
		Body.flip_h = false
	match state.movement:
		Movement.WALK:
			Body.set_animation("default")
			Legs.set_animation("walk")
			pass
		Movement.GRIP:
			Body.set_animation("grip")
			Legs.set_animation("grip")
		Movement.JUMP_CHARGE:
			Legs.play("charge_jump")
			Body.play("charge_jump")
			return
#	set animation defaults to start playing for some reason
	Legs.stop()	
#	TODO - we probably have to make this work with delta to make frames match movement
	var numberOfFrames = Legs.get_sprite_frames().get_frame_count(Legs.get_animation())
	match state.direction:
		Direction.CENTER:
			pass
		Direction.LEFT:
			#	TODO - figure out how to improve logic
			if (Legs.get_frame() == 0):
				Legs.set_frame(7)
			else:
				Legs.set_frame((Legs.get_frame() - 1))		
		Direction.RIGHT:
			Legs.set_frame((Legs.get_frame() + 1) % numberOfFrames)
