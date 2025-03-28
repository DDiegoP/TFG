class_name ReaSensorManager extends Node

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

@export var client : OSCClient

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
	match interaction.control:
		Controls.Volume:
			pass
		Controls.Pan:
			if(interaction.trackNum==0):
				client.send_message("/master/pan",[interaction.result])
			pass
		Controls.Custom:
			pass

func getInteractionAt(index) -> Interaction:
	return interactions[index]
