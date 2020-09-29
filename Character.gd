extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animate()
	
func animate():

	if (Input.is_action_pressed("jump")):
		$Legs.play("charge_jump")
		$Body.play("charge_jump")
	elif (Input.is_action_pressed("grip") and Input.is_action_pressed("right")):
		$Legs.play("grip")
		$Body.play("grip")
	elif (Input.is_action_pressed("grip") and Input.is_action_pressed("left")):
		$Legs.play("grip", true)
		$Body.play("grip")
	elif ($Legs.animation == "walk" or $Legs.animation == "grip") and $Legs.frame != 0:
		print($Legs.frame)
		pass
	elif (Input.is_action_pressed("grip")):
		$Legs.play("grip_idle")
		$Body.play("grip")
	elif (Input.is_action_pressed("right")):
		$Legs.play("walk")
		$Body.play("idle")
	elif (Input.is_action_pressed("left")):
		$Legs.play("walk", true)
		$Body.play("idle")
	else:
		$Body.play("idle")
		$Legs.play("idle")
