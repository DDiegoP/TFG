extends RigidBody3D

#Velocidad de lerpeo entre los carrilas
@export var lerpSpeed = 10
#Posiciones designadas del jugador
@export var playerPositions: Array[Marker3D] = []
#Indice de posicion del player
@export var currentIndex = 0
#Posicion inicial del player
var initialPos
#Posicion a la que el jugador tiene que desplazarse
var targetPos
#Posicion inicial en la que el usuario pulsa en pantalla
var initSwipePos
#Posicion en la que el usuario termina de pulsar en pantalla
var finalSwipePos

# Se conectan las señales y se setea la posicion del jugador a la del indice puesto
func _ready():
	targetPos = playerPositions[currentIndex]
	initialPos = currentIndex
	position = targetPos.global_position
	

func _unhandled_input(event):
	if(event.is_action_pressed("LMB")):
		initSwipePos = event.get_position()
	if(event.is_action_released("LMB")):
		finalSwipePos = event.get_position()
		handleSwipe()

# Se mueve la posicion a la nueva mediante un lerp.
func _process(delta):
	global_position = global_position.lerp(targetPos.global_position, delta*lerpSpeed)

# Calcula la direccion del swipe
func handleSwipe():
	if(initSwipePos.x-finalSwipePos.x>0):
		moveLeft()
	else:
		moveRight()

# Se mueve a la izquierda el jugador si es posible
func moveLeft():
	if(currentIndex > 0):
		currentIndex -= 1;
		targetPos = playerPositions[currentIndex];
		
# Se mueve a la izquierda el jugador si es posible
func moveRight():
	if(currentIndex < playerPositions.size()-1):
		currentIndex += 1;
		targetPos = playerPositions[currentIndex];

# Al entrar en colisión se reinicia la posición, aquí se "moriria"
func _on_body_entered(body):
	targetPos = playerPositions[initialPos]
	currentIndex = initialPos
