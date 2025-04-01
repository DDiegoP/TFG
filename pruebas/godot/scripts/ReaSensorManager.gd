class_name ReaSensorManager extends Node

enum Sensors {
	None,
	Gyroscope,
	MagneticField,
	Accelerometer
}

enum Controls {
	Volume,
	Pan,
	Mute,
	Solo,
	Custom
}

#Array con las interacciones que se van a ejecutar
@export var interactions : Array[Interaction] = []

#Cliente de OSC
@export var client : OSCClient

#Bucle de funcionamiento de interacciones
func _process(delta):
	for interaction in interactions:
		getSensorData(interaction)
		if(interaction.callable):
			interaction.callable.call(interaction)
		sendInfo(interaction)

#Se obtiene la informacion de los sensores haciendo uso del input de godot
func getSensorData(interaction):
	match interaction.sensor:
		Sensors.Gyroscope:
			interaction.sensorValue = Input.get_gyroscope()
		Sensors.MagneticField:
			interaction.sensorValue = Input.get_magnetometer()
		Sensors.Accelerometer:
			interaction.sensorValue = Input.get_accelerometer()

#Haciendo uso de OSC Client se envia la informacion a Reaper
func sendInfo(interaction):
	match interaction.control:
		Controls.Volume:
			if(interaction.trackNum==0):
				client.send_message("/master/volume",[interaction.result])
			else:
				client.send_message(str("/track/",interaction.trackNum,"/volume"), [interaction.result])
			pass
		Controls.Pan:
			if(interaction.trackNum==0):
				client.send_message("/master/pan",[interaction.result])
			else:
				client.send_message(str("/track/",interaction.trackNum,"/pan"), [interaction.result])
			pass
		Controls.Mute:
			if(interaction.trackNum==0):
				client.send_message("/master/mute",[interaction.result])
			else:
				client.send_message(str("/track/",interaction.trackNum,"/mute"), [interaction.result])
			pass
		Controls.Solo:
			if(interaction.trackNum==0):
				client.send_message("/master/solo",[interaction.result])
			else:
				client.send_message(str("/track/",interaction.trackNum,"/solo"), [interaction.result])
			pass
		Controls.Custom:
			client.send_message(interaction.customRoute, [interaction.result])
			pass

#Devuelve la interaccion del indice solicitado
func getInteractionAt(index) -> Interaction:
	return interactions[index]
