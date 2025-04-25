class_name PinballController extends Node2D

const REA_INIT_VALUE = 0.5
const SHAKE_VALUE = 15
const INIT_TEXT = "Current Chance: "
const FALLEN_POS = 1000

#Boton izquierdo
@export var ButtonLeft : Button
#Boton derecho
@export var ButtonRight : Button
#Pala izquierda
@export var PaddleL : RigidBody2D
#Pala derecha
@export var PaddleR : RigidBody2D

@export var ball : RigidBody2D

#Grados que giran las palas
@export var turnDegrees = 45
#Velocidad de giro
@export var turnSpeed = 10

@export var rsManager : ReaSensorManager

var accelerValues

@export var reaValue = REA_INIT_VALUE

@export var textLabel : RichTextLabel

#Grados iniciales de la pala izquierda
var initDegreesL
#Grados iniciales de la pala derecha
var initDegreesR
#Posicion inicial de la bola
var initialBallPos
#Grados objetivo de la pala izquierda
var targetDegreesL
#Grados objetivo de la pala derecha
var targetDegreesR

#Asignación inicial de valores
func _ready():
	initDegreesL = PaddleL.rotation
	initDegreesR = PaddleR.rotation
	initialBallPos = ball.global_position
	targetDegreesL = initDegreesL
	targetDegreesR = initDegreesR
	rsManager.getInteractionAt(0).callable = Callable(self, "sendValue")
	updateText()

#Movimiento de las palas y comprobacion de caida de bola
func _process(delta):
	checkBallFall()
	PaddleL.set_rotation(move_toward(PaddleL.rotation, targetDegreesL, delta * turnSpeed))
	PaddleR.set_rotation(move_toward(PaddleR.rotation, targetDegreesR, delta * turnSpeed))
	if(accelerValues && abs(accelerValues.x)>SHAKE_VALUE && abs(accelerValues.y)>SHAKE_VALUE && abs(accelerValues.z)>SHAKE_VALUE ):
		reaValue = REA_INIT_VALUE

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

#Aumenta el valor del bias en reaper
func increaseValue():
	reaValue = clamp(reaValue + 0.05, 0.25, 0.75)
	
	updateText()

#Reduce el valor del bias en reaper
func decreaseValue():
	reaValue = clamp(reaValue - 0.05, 0.25, 0.75)
	
	updateText()

#Pone el valor de la interaccion a reaValue
func sendValue(interaction):
	interaction.result = reaValue
	accelerValues = interaction.sensorValue

#Actualiza el texto que se muestra con los valores de reaValue entre 0 y 100 % correspondiendo a 0.25 y 0.75
func updateText():
	textLabel.text = str(INIT_TEXT, round(((reaValue - 0.25) * 2) * 100), "%")

#Comprueba si la bola se ha caido y si es así resetea su posición
func checkBallFall():
	if ball.global_position.y > FALLEN_POS:
		ball.global_position = initialBallPos
		ball.linear_velocity = Vector2.ZERO
