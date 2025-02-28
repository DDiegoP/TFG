extends Node2D

@export var ButtonLeft : Button
@export var ButtonRight : Button
@export var PaddleL : RigidBody2D
@export var PaddleR : RigidBody2D

@export var turnDegrees = 45
@export var turnSpeed = 10
var initDegreesL
var initDegreesR
var targetDegreesL
var targetDegreesR

func _ready():
	initDegreesL = PaddleL.rotation
	initDegreesR = PaddleR.rotation
	targetDegreesL = initDegreesL
	targetDegreesR = initDegreesR

func _process(delta):
	PaddleL.set_rotation(move_toward(PaddleL.rotation, targetDegreesL, delta * turnSpeed))
	PaddleR.set_rotation(move_toward(PaddleR.rotation, targetDegreesR, delta * turnSpeed))

func _on_button_left_button_down():
	targetDegreesL = initDegreesL + deg_to_rad(-turnDegrees)

func _on_button_right_button_down():
	targetDegreesR = initDegreesR + deg_to_rad(turnDegrees)

func _on_button_left_button_up():
	targetDegreesL = initDegreesL

func _on_button_right_button_up():
	targetDegreesR = initDegreesR
