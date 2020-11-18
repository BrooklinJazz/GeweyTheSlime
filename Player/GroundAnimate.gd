extends Node

class_name GroundAnimate

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
	if (Player.state.direction.x.left):
		shouldFlip = true
	elif Player.state.direction.x.right:
		shouldFlip = false
	if(Player.state.airborne.on_ceiling and !Player.state.direction.x.center):
		shouldFlip = not shouldFlip
	return shouldFlip
	
func play_current_animation():
	if Player.state.movement.walk:
		self.body.set_animation("default")
		self.legs.set_animation("walk")
	if Player.state.movement.grip:
		self.body.set_animation("grip")
		self.legs.set_animation("grip")
	if Player.state.movement.charge_jump:
		self.legs.play("charge_jump")
		self.body.play("charge_jump")
		return
	# set animation defaults to start playing for some reason
	self.legs.stop()
	self.legs.set_frame(get_next_frame())
	
func get_next_frame() -> int:
	#	TODO - we probably have to make this work with delta to make frames match Enums.Movement
	var numberOfFrames = self.legs.get_sprite_frames().get_frame_count(self.legs.get_animation())
	var frameIndex = self.legs.get_frame()
	if (Player.state.direction.x.left or Player.state.direction.y.down):
		frameIndex = posmod(frameIndex - 1, numberOfFrames)
	elif (Player.state.direction.x.right or Player.state.direction.y.up):
		frameIndex = posmod(frameIndex + 1, numberOfFrames)
	return frameIndex
