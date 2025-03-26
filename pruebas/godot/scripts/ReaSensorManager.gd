extends Node

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

@export var interactions : Array[Interaction] = []

func _process(delta):
	for interaction in interactions:
		getSensorData(interaction)
		if(interaction.callable):
			interaction.callable.call(interaction)
		sendInfo(interaction)

func getSensorData(interaction):
	match interaction.sensor:
		Sensors.Gyroscope:
			interaction.sensorValue = Input.get_gyroscope()
		Sensors.MagneticField:
			interaction.sensorValue = Input.get_magnetometer()
		Sensors.Accelerometer:
			interaction.sensorValue = Input.get_accelerometer()
		
func sendInfo(interaction):
	match interaction.Controls:
		Controls.Volume:
			pass
		Controls.Pan:
			pass
		Controls.Custom:
			pass
