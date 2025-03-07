class_name NoteSpawner
extends Node

#Contador de tiempo
var timer = 0
#Indice del array actual
var currentIndex = 0
#Indice maximo de puntos de spawn
var maxIndex = 0

#Puntos de spawn de las notas
@export var spawnPoints: Array[Marker2D] = []
#Array con strings de las notas
@export var notes : Array[int] = []
#Tiempo en el que van a aparecer las notas
@export var noteStamps : Array[float] = []

func _ready():
	maxIndex = spawnPoints.size()-1

# Avanza un timer que recorre noteStamps y las va spawneando en las cuerdas de forma aleatoria
# en su tiempo correspondiente al llegar al final vuelve al inicio de las notas
func _process(delta):
	timer += delta
	if(noteStamps[currentIndex] < timer):
		var chosen = randi_range(0,maxIndex)
		spawnPoints[chosen].spawnNote(notes[currentIndex])
		if(currentIndex + 1 == noteStamps.size() || currentIndex + 1 == notes.size()):
			currentIndex = 0
			timer = 0
		else:
			currentIndex += 1
	
func transferData(times,innotes):
	notes = []
	noteStamps = []
	for time in times:
		noteStamps.push_back(time)	 
	pass
	
	for note in innotes:
		notes.push_back(note)	 
	pass
	print("BasslPLayer data Transfered")
