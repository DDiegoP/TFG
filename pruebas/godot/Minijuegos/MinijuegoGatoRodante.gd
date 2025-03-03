extends Node2D

@export var ball : RigidBody2D
@export var ballSpeed : float

var forceToApply : Vector2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ball.apply_central_impulse(forceToApply)


func changeForce(newForce):
	forceToApply = Vector2(newForce, 0)


func _on_button_left_button_down():
	changeForce(-ballSpeed)


func _on_button_left_button_up():
	changeForce(0)


func _on_button_right_button_down():
	changeForce(ballSpeed)


func _on_button_right_button_up():
	changeForce(0)
