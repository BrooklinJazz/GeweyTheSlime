extends Node

class_name PlayerAnimate

var body
var legs
var sprite

func _init(Body, Legs, Sprite):
	body = Body
	legs = Legs
	sprite = Sprite
	
func main():
	self.set_facing_direction()
	self.play_current_animation()
	
func set_facing_direction():
	if (Player.state.airborn == Enums.Airborn.ON_CEILING):
		self.sprite.rotation_degrees = 180
	else:
		self.sprite.rotation_degrees = 0
	if (Player.state.direction == Enums.Direction.LEFT):
		self.body.flip_h = true
	elif (Player.state.direction == Enums.Direction.RIGHT):
		self.body.flip_h = false

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
