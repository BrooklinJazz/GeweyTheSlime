extends Node

class_name WallAnimate

var body
var legs

func _init(Body, Legs):
	body = Body
	legs = Legs
	
func animate():
	self.set_facing_direction()
	self.play_current_animation()
	
func set_facing_direction():
	self.body.flip_h = get_flip_h(self.body.flip_h)

func get_flip_h(previous_flip_h: bool):
	if (Player.state.direction.y.down):
		return true
	elif Player.state.direction.y.up:
		return false
	else:
		return previous_flip_h
	
func play_current_animation():
	self.body.set_animation("grip")
	self.legs.set_animation("grip")
	self.legs.set_frame(get_next_frame())
	
func get_next_frame() -> int:
	#	TODO - we probably have to make this work with delta to make frames match Enums.Movement
	var numberOfFrames = self.legs.get_sprite_frames().get_frame_count(self.legs.get_animation())
	var frameIndex = self.legs.get_frame()
	if (Player.state.direction.y.down):
		frameIndex = posmod(frameIndex - 1, numberOfFrames)
	elif (Player.state.direction.y.up):
		frameIndex = posmod(frameIndex + 1, numberOfFrames)
	return frameIndex
