extends Node

#Contador de tiempo
var timer = 0
#Indice del array actual
var currentIndex = 0

#Puntos de spawn de las notas
@export var bassStrings: Array[Marker2D] = []
#Array con strings de las notas
@export var stringNotes = []
#Tiempo en el que van a aparecer las notas
@export var noteStamps = []

# Avanza un timer que recorre noteStamps y las va spawneando en las cuerdas de forma aleatoria
# en su tiempo correspondiente al llegar al final vuelve al inicio de las notas
func _process(delta):
	timer += delta
	if(noteStamps[currentIndex] < timer):
		var chosen = randi_range(0,3)
		bassStrings[chosen].spawnNote(stringNotes[currentIndex])
		if(currentIndex + 1 == noteStamps.size() || currentIndex + 1 == stringNotes.size()):
			currentIndex = 0
			timer = 0
		else:
			currentIndex += 1
	
