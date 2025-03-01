extends Node2D

#Boton izquierdo
@export var ButtonLeft : Button
#Boton derecho
@export var ButtonRight : Button
#Pala izquierda
@export var PaddleL : RigidBody2D
#Pala derecha
@export var PaddleR : RigidBody2D

#Grados que giran las palas
@export var turnDegrees = 45
#Velocidad de giro
@export var turnSpeed = 10

#Grados iniciales de la pala izquierda
var initDegreesL
#Grados iniciales de la pala derecha
var initDegreesR
#Grados objetivo de la pala izquierda
var targetDegreesL
#Grados objetivo de la pala derecha
var targetDegreesR

#Asignación inicial de valores
func _ready():
	initDegreesL = PaddleL.rotation
	initDegreesR = PaddleR.rotation
	targetDegreesL = initDegreesL
	targetDegreesR = initDegreesR

#Movimiento de las palas
func _process(delta):
	PaddleL.set_rotation(move_toward(PaddleL.rotation, targetDegreesL, delta * turnSpeed))
	PaddleR.set_rotation(move_toward(PaddleR.rotation, targetDegreesR, delta * turnSpeed))

#Receptor de señal de presion del boton izquierdo, cambia los grados objetivos para que se active la pala
func _on_button_left_button_down():
	targetDegreesL = initDegreesL + deg_to_rad(-turnDegrees)

#Receptor de señal de presion del boton derecho, cambia los grados objetivos para que se active la pala
func _on_button_right_button_down():
	targetDegreesR = initDegreesR + deg_to_rad(turnDegrees)

#Receptor de señal de boton levantado del boton izquierdo, restablece los grados objetivos a los iniciales
func _on_button_left_button_up():
	targetDegreesL = initDegreesL

#Receptor de señal de boton levantado del boton derecho, restablece los grados objetivos a los iniciales
func _on_button_right_button_up():
	targetDegreesR = initDegreesR
