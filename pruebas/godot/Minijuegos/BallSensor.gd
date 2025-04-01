extends StaticBody2D

enum SensorType {
	Increase,
	Decrease
}

@export var pinballController : PinballController

@export var type : SensorType

var collision = false

var currentValue = 0.5

#Metodo receptor de senial de colision de la bola, comprueba si el cuerpo con el que ha colisionado es el mismo que
#tiene el script y si es así se ejecuta 
func _on_ball_body_entered(body):
	if(body == get_node(".")):
		collision = true
		if(type == SensorType.Increase):
			pinballController.increaseValue()
		if(type == SensorType.Decrease):
			pinballController.decreaseValue()
