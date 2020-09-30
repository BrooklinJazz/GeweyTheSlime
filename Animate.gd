extends Node

class_name PlayerAnimate

func main(Body, Legs):
	if (Player.state.direction == Player.Direction.LEFT):
		Body.flip_h = true
	elif (Player.state.direction == Player.Direction.RIGHT):
		Body.flip_h = false
	match Player.state.movement:
		Player.Movement.WALK:
			Body.set_animation("default")
			Legs.set_animation("walk")
			pass
		Player.Movement.GRIP:
			Body.set_animation("grip")
			Legs.set_animation("grip")
		Player.Movement.JUMP_CHARGE:
			Legs.play("charge_jump")
			Body.play("charge_jump")
			return
#	set animation defaults to start playing for some reason
	Legs.stop()	
#	TODO - we probably have to make this work with delta to make frames match Player.Movement
	var numberOfFrames = Legs.get_sprite_frames().get_frame_count(Legs.get_animation())
	match Player.state.direction:
		Player.Direction.CENTER:
			pass
		Player.Direction.LEFT:
			#	TODO - figure out how to improve logic
			if (Legs.get_frame() == 0):
				Legs.set_frame(7)
			else:
				Legs.set_frame((Legs.get_frame() - 1))		
		Player.Direction.RIGHT:
			Legs.set_frame((Legs.get_frame() + 1) % numberOfFrames)
