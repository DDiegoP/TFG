extends StaticBody2D

#Enum con tipos de accion que puede ejercer el sensor
enum SensorType {
	Increase,
	Decrease
}

#Controlador del minijuego del pinball
@export var pinballController : PinballController

#Tipo de accion que ejerce el sensor
@export var type : SensorType

#Metodo receptor de senial de colision de la bola, comprueba si el cuerpo con el que ha colisionado es el mismo que
#tiene el script y si es así se ejecuta 
func _on_ball_body_entered(body):
	if(body == get_node(".")):
		if(type == SensorType.Increase):
			pinballController.increaseValue()
		if(type == SensorType.Decrease):
			pinballController.decreaseValue()
