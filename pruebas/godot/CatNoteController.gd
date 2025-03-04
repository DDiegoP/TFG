extends Area2D

#Velocidad de la nota bajando por el carril
const SPEED = 100

#Posicion y en la que va a desaparecer la nota y fallarse
const DEATH_ZONE = 800

#String de la key correspondiente de la nota
var key = ""

var ball : RigidBody2D

#Se desplaza la nota, hacia abajo y si baja de la death zone se elimina
func _process(delta):
	position.y += delta * SPEED
	if (position.y> DEATH_ZONE):
		queue_free();


func _on_body_entered(body):
	if(body == ball):
		print(key)
		queue_free()
