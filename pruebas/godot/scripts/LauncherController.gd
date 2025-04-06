extends RigidBody2D

const NORTH_VALUE = 30.0

const SOUTH_VALUE = -25.0

@export var speed : float

@export var rsManager : ReaSensorManager

var currSpeed = 0

var auxMg = 0.0

func _ready():
	set_gravity_scale(0)

func _process(delta):
	angular_velocity = currSpeed
	
	var mgValue = rsManager.getInteractionAt(0).sensorValue
	var angle = 0
	if(mgValue):
		var x = mgValue.x
		var y = mgValue.y
		if (atan2(y, x) >= 0):
			angle = atan2(y, x) * (180 / PI);
		else:
			angle = (atan2(y, x) + 2 * PI) * (180 / PI);
		
		angle = deg_to_rad(angle)
		
		rotation = lerp_angle(rotation, angle, delta)

func _on_button_left_button_down():
	currSpeed = -speed


func _on_button_right_button_down():
	currSpeed = speed


func _on_button_left_button_up():
	currSpeed = 0


func _on_button_right_button_up():
	currSpeed = 0
