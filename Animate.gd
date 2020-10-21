extends Node

class_name PlayerAnimate

var body
var legs
var sprite

func _init(Body, Legs):
	body = Body
	legs = Legs
	
func main():
	self.set_facing_direction()
	self.play_current_animation()
	
func set_facing_direction():
	self.body.flip_h = self.get_flip_h()

func get_flip_h() -> bool:
	var flip_h = self.body.flip_h
	match Player.state.direction:
		Enums.Direction.LEFT:
			flip_h = true
		Enums.Direction.RIGHT:
			flip_h = false
	if(Player.state.airborne == Enums.Airborne.ON_CEILING):
		flip_h = not flip_h
	return flip_h

func play_current_animation():
	match Player.state.movement:
		Enums.Movement.WALK:
			self.body.set_animation("default")
			self.legs.set_animation("walk")
		Enums.Movement.GRIP:
			self.body.set_animation("grip")
			self.legs.set_animation("grip")
		Enums.Movement.JUMP_CHARGE:
			self.legs.play("charge_jump")
			self.body.play("charge_jump")
			return
#	set animation defaults to start playing for some reason
	self.legs.stop()
	self.iterate_animation()
	
func iterate_animation():
	#	TODO - we probably have to make this work with delta to make frames match Enums.Movement
	var numberOfFrames = self.legs.get_sprite_frames().get_frame_count(self.legs.get_animation())
	match Player.state.direction:
		Enums.Direction.CENTER:
			pass
		Enums.Direction.LEFT:
			#	TODO - figure out how to improve logic
			if (self.legs.get_frame() == 0):
				self.legs.set_frame(7)
			else:
				self.legs.set_frame((self.legs.get_frame() - 1))		
		Enums.Direction.RIGHT:
			self.legs.set_frame((self.legs.get_frame() + 1) % numberOfFrames)
