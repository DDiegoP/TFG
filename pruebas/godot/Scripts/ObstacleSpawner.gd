extends Node

#Contador de tiempo
var timer = 0
#Indice del array actual
var currentIndex = 0

#Puntos de spawn de los obstaculos
@export var guitarStrings: Array[Marker3D] = []
#Array con strings de notas de obstaculos
@export var stringNotes = []
#Array con los time stamps en los que se van a spawnear las notas
@export var noteStamps = []
#Prefab de obstaculo
@export var obstacle : PackedScene

# Se avanza el timer y si pasa el timeStamp que se esta teniendo en cuenta se avanaza el contador
# y se spawnea una nota en una de las posiciones designadas aleatoria
func _process(delta):
	timer += delta
	if(noteStamps[currentIndex] < timer):
		var chosen = randi_range(0,5)
		spawnNote(guitarStrings[chosen],stringNotes[currentIndex])
		if(currentIndex + 1 == noteStamps.size() || currentIndex + 1 == stringNotes.size()):
			currentIndex = 0
			timer = 0
		else:
			currentIndex += 1

# Se spawnea la nota en la posicion y con la string dadas
func spawnNote(position, noteToSpawn):
	var newObstacle = obstacle.instantiate()
	position.add_child(newObstacle)
	newObstacle.key = noteToSpawn
