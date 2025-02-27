extends RigidBody3D

#Velocidad a la que se desplaza el obstaculo
const SPEED = 100
#Posicion a partir de la que el obstaculo se elimina y se considera esquivado
const DEATH_ZONE = 0
#Key del obstaculo
var key = ""

# Se mueve el obstaculo y si pasa de la death zone se elimina y escribe la nota por consola
func _process(delta):
	translate(Vector3(0, 0, delta * SPEED))
	if (global_position.z > DEATH_ZONE):
		print_debug(key)
		queue_free();
