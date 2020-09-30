extends Node

class_name PlayerAnimator

func animate(Body, Legs):
	if (PlayerVariables.state.direction == PlayerVariables.Direction.LEFT):
		Body.flip_h = true
	elif (PlayerVariables.state.direction == PlayerVariables.Direction.RIGHT):
		Body.flip_h = false
	match PlayerVariables.state.movement:
		PlayerVariables.Movement.WALK:
			Body.set_animation("default")
			Legs.set_animation("walk")
			pass
		PlayerVariables.Movement.GRIP:
			Body.set_animation("grip")
			Legs.set_animation("grip")
		PlayerVariables.Movement.JUMP_CHARGE:
			Legs.play("charge_jump")
			Body.play("charge_jump")
			return
#	set animation defaults to start playing for some reason
	Legs.stop()	
#	TODO - we probably have to make this work with delta to make frames match PlayerVariables.Movement
	var numberOfFrames = Legs.get_sprite_frames().get_frame_count(Legs.get_animation())
	match PlayerVariables.state.direction:
		PlayerVariables.Direction.CENTER:
			pass
		PlayerVariables.Direction.LEFT:
			#	TODO - figure out how to improve logic
			if (Legs.get_frame() == 0):
				Legs.set_frame(7)
			else:
				Legs.set_frame((Legs.get_frame() - 1))		
		PlayerVariables.Direction.RIGHT:
			Legs.set_frame((Legs.get_frame() + 1) % numberOfFrames)
