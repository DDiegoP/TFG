extends Node2D

#Bola sobre la que se aplica la fuerza
@export var ball : RigidBody2D
#Valor de fuerza que se aplica a la vola
@export var ballSpeed : float

#Fuerza que se esta aplicando en la bola
var forceToApply : Vector2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var accelerForce = Input.get_accelerometer()
	ball.apply_central_impulse(forceToApply+ Vector2(accelerForce.x, 0))

#Se cambia el vector de fuerza horizontal que se aplica a el nuevo valor
func changeForce(newForce):
	forceToApply = Vector2(newForce, 0)

#Al pulsar el boton izquierdo se añade fuerza a la izquierda
func _on_button_left_button_down():
	changeForce(-ballSpeed)

#Al levantar el boton izquierdo se añade elimina la fuerza
func _on_button_left_button_up():
	changeForce(0)

#Al pulsar el boton derecho se añade fuerza a la derecha
func _on_button_right_button_down():
	changeForce(ballSpeed)

#Al levantar el boton derecho se añade elimina la fuerza
func _on_button_right_button_up():
	changeForce(0)
