extends StaticBody2D

#Nota que escribir al chocar con la bola
@export var key : String

#Metodo receptor de senial de colision de la bola, comprueba si el cuerpo con el que ha colisionado es el mismo que
#tiene el script y si es así se ejecuta
func _on_ball_body_entered(body):
	if(body == get_node(".")):
		print(key)
