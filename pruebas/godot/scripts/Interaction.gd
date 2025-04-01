class_name Interaction extends Resource

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

#Sensor del que recoger información
@export var sensor : Sensors = Sensors.Gyroscope
#Valor recogido por el sensor
var sensorValue 
#Numero de track a la que enviar informacion, 0 para master cuando tenga sentido
@export var trackNum : int = 0
#Tipo de control de la pista a modificar
@export var control : Controls = Controls.Volume
#Con el control en custom, ruta OSC a enviar
@export var customRoute : String = ""
#Callback en el que definir la interaccion y el resultado de la misma
var callable : Callable
#Resultado de la interaccion, paramtro/s que se mandaran por OSC
var result
