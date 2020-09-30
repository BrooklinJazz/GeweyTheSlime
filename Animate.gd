extends Node

class_name PlayerAnimate

func main(Body, Legs):
	if (Player.state.direction == Enums.Direction.LEFT):
		Body.flip_h = true
	elif (Player.state.direction == Enums.Direction.RIGHT):
		Body.flip_h = false
	match Player.state.movement:
		Enums.Movement.WALK:
			Body.set_animation("default")
			Legs.set_animation("walk")
			pass
		Enums.Movement.GRIP:
			Body.set_animation("grip")
			Legs.set_animation("grip")
		Enums.Movement.JUMP_CHARGE:
			Legs.play("charge_jump")
			Body.play("charge_jump")
			return
#	set animation defaults to start playing for some reason
	Legs.stop()	
#	TODO - we probably have to make this work with delta to make frames match Enums.Movement
	var numberOfFrames = Legs.get_sprite_frames().get_frame_count(Legs.get_animation())
	match Player.state.direction:
		Enums.Direction.CENTER:
			pass
		Enums.Direction.LEFT:
			#	TODO - figure out how to improve logic
			if (Legs.get_frame() == 0):
				Legs.set_frame(7)
			else:
				Legs.set_frame((Legs.get_frame() - 1))		
		Enums.Direction.RIGHT:
			Legs.set_frame((Legs.get_frame() + 1) % numberOfFrames)
