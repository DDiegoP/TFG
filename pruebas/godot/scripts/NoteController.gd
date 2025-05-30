extends Area2D

#Velocidad de la nota bajando por el carril
const SPEED = 110

#Posicion y en la que va a desaparecer la nota y fallarse
const DEATH_ZONE = 800

#@export var perfectMargin = 0.1
var perfectMargin = 0.01
@export var aspect : Sprite2D

#String de la key correspondiente de la nota
var key = ""

#Tiempo perfecto en el que se tendría que destruir la nota
var targetTime = 0
var timer = 0

#Se desplaza la nota, hacia abajo y si baja de la death zone se elimina
func _process(delta):
	timer += delta
	position.y += delta * SPEED
	if (position.y> DEATH_ZONE):
		queue_free();
	if (timer ==targetTime || (timer >targetTime+ perfectMargin && timer < targetTime+ 2*perfectMargin )):
		print_debug("Perfecto")
	#print(timer)
	##print(targetTime)
#Funcion conectada al boton de su carril, al apretarse el boton si las areas estan una encima de
#la otra se elimina y se aparece la key por consola
func _on_boton_pressed():
	#cuidadp que las notas colisionaban entre si 	
	if(get_overlapping_areas().size()>0):
		if(timer > targetTime - perfectMargin || timer < targetTime + perfectMargin):
			print_debug("Perfecto")
		print_debug(key)
		queue_free();

func setAspect (img):
	aspect.texture = img
	pass
