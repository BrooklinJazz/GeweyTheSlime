extends Node

class_name PlayerAnimate

var body
var legs

func _init(Body, Legs):
	body = Body
	legs = Legs
	
func animate():
	self.set_facing_direction()
	self.play_current_animation()
	
func set_facing_direction():
	self.body.flip_h = get_direction(self.body.flip_h)

func get_direction(flip: bool):
	var shouldFlip = flip
	match Player.state.direction.x:
		Enums.Direction.LEFT:
			shouldFlip = true
		Enums.Direction.RIGHT:
			shouldFlip = false
	if(Player.state.airborne == Enums.Airborne.ON_CEILING and Player.state.direction.x != Enums.Direction.CENTER):
		shouldFlip = not shouldFlip
	return shouldFlip
	
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
	self.legs.set_frame(get_next_frame())
	
func get_next_frame() -> int:
	#	TODO - we probably have to make this work with delta to make frames match Enums.Movement
	var numberOfFrames = self.legs.get_sprite_frames().get_frame_count(self.legs.get_animation())
	var frameIndex = self.legs.get_frame()
	match Player.state.direction.x:
		Enums.Direction.LEFT:
			frameIndex = posmod(frameIndex - 1, numberOfFrames)
		Enums.Direction.RIGHT:
			frameIndex = posmod(frameIndex + 1, numberOfFrames)
	return frameIndex
