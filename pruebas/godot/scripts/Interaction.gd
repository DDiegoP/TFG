@tool
class_name Interaction extends Resource

enum Sensors {
	Gyroscope,
	MagneticField,
	Accelerometer
}

enum Controls {
	Volume,
	Pan,
	Custom
}

@export var active : bool = false
@export var sensor : Sensors = Sensors.Gyroscope
var sensorValue 
@export var trackNum : int = 0
@export var control : Controls = Controls.Volume
@export var customRoute : String = ""
var callable : Callable
