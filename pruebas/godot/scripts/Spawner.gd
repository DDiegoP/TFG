class_name NoteSpawner
extends Node
#Estos son los arrays que van a llegar desde reaper : 
#Notas [54, 53, 54, 57, 52, 53, 52, 57, 54, 53, 54, 57, 52, 53, 52]
#Tiempos [0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5]

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
@export var noteSpawnStamps : Array[float] = []
#Tiempo en el que la nota se tendría que pulsar
@export var noteStamps : Array[float] = []


var count=0
var noteSpeed = 0.5
#asignaremos cada nota a un canal
var  SpawnPointMap= {} 

func _ready():
	maxIndex = spawnPoints.size()-1

# Avanza un timer que recorre noteSpawnStamps y las va spawneando en las cuerdas de forma aleatoria
# en su tiempo correspondiente al llegar al final vuelve al inicio de las notas
func _process(delta):
	#testeando para el bug 

	count+=1
	if(count > 45):
		count =0
		#spawnPoints[0].spawnNote(34,0.5)
		
	pass
	
	timer += delta
	if(noteSpawnStamps.size()>0):
		if(currentIndex >= noteSpawnStamps.size()-1):#se acabo la cancion vuevlo a empezar
			currentIndex = 0
			timer=0
		else: #siguiente nota que tengo que spanear si la hay
			var downtime=  noteSpawnStamps[currentIndex] -timer
			if downtime <=0 and notes[currentIndex] !=0:
				var chosen = randi_range(0,maxIndex)
				SpawnPointMap[notes[currentIndex]].spawnNote(notes[currentIndex], noteStamps[currentIndex]-timer)
				currentIndex += 1
				
		#if(currentIndex  >= noteSpawnStamps.size() -1 || currentIndex  >= notes.size()-1):
			#currentIndex = 0
			#timer = 0
		#else:
			#currentIndex += 1
		#if(noteSpawnStamps[currentIndex] < timer):
			#var chosen = randi_range(0,maxIndex)
			#spawnPoints[chosen].spawnNote(notes[currentIndex], noteStamps[currentIndex]-timer)
	##print(timer)
func transferData(times,innotes,curtime):
	timer=curtime
	notes = []
	noteSpawnStamps = []
	noteStamps = []
	currentIndex=0
	#var speed = spawnPoints[0].getNoteSpeed() este metodo no exisitia 
	var speed = 0.2
	var targetPos = spawnPoints[0].position.y
	for time in times:
		
		noteSpawnStamps.push_back((time - targetPos/speed))	 
		var t = time
		noteStamps.push_back(t)
		#nos aseguramos de empezar en la nota que toca
		if( t < timer):
			currentIndex = currentIndex +1
		if time == 0:
			break
			
	pass
	var parsednotes = []
	var si = 0 #spawnpoints index
	for note in innotes:
		notes.push_back(note)	
		if not parsednotes.has(note) and note !=0:
			#SpawnPointMap.set(key : note, value : spawnPoints[si])
			if(si<4):
				SpawnPointMap[note] = spawnPoints[si]
				si+=1
				parsednotes.push_back(note)
			else:
				print("Bass line only supports 4 diferent notes")
				break
		
	pass
	
	print("BasslPLayer data Transfered")
