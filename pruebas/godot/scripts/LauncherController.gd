extends RigidBody2D

@export var speed : float
var currSpeed = 0

func _ready():
	set_gravity_scale(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	angular_velocity = currSpeed
	#print(rotation_degrees)


func _on_button_left_button_down():
	currSpeed = -speed


func _on_button_right_button_down():
	currSpeed = speed


func _on_button_left_button_up():
	currSpeed = 0


func _on_button_right_button_up():
	currSpeed = 0
