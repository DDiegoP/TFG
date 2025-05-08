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

#cuanto tardamos en descender del spawnpoint al boton 
var noteTravelTime = 150 
#Asumiremos que los 4 spawners y los 4 botones son equidistantes
var travelDistance = 0
#Puntos de spawn de las notas
@export var spawnPoints: Array[Marker2D] = []
#Array con strings de las notas
@export var notes : Array[int] = []
#Tiempo en el que van a aparecer las notas
@export var noteSpawnStamps : Array[float] = []
#Tiempo en el que la nota se tendría que pulsar
@export var noteStamps : Array[float] = []

#Ubico un boton para calcular distancias
@export var buttonArea : CollisionShape2D ; 

var count=0
#var noteSpeed = 0.65
var noteSpeed = 110
#asignaremos cada nota a un canal
var  SpawnPointMap= {} 

#informacion del bucle de la pieza si lo hay 
var loopinfo=[]
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
		if(timer >= loopinfo[1]):#se acabo la cancion vuevlo a empezar
			currentIndex = 0
			timer=loopinfo[0]
		elif(currentIndex<notes.size()) :#siguiente nota que tengo que spanear si la hay
			var travelDistance = absf (spawnPoints[0].position.y -buttonArea.transform.get_origin()[1])
				
			##print(travelDistance)
			var traveltime = (travelDistance/(noteSpeed))
			print("travel time")
			print(traveltime)
			
			var downtime=  abs(noteSpawnStamps[currentIndex] -timer)
			print(downtime)
			if downtime >=traveltime and notes[currentIndex] !=0:
				# v = d/t  t = d/v
				#travelDistance = absf (spawnPoints[0].position.y -buttonArea.transform.get_origin()[1])
				
				#print(travelDistance)
				# traveltime = (travelDistance/(noteSpeed*delta))
				#puede que me acabe de conctar en medio y cuandren notas en medio d euna cuerda
				var advancedDistance = 0
				if(downtime<traveltime):
					advancedDistance= downtime/traveltime
				SpawnPointMap[notes[currentIndex]].spawnNote(notes[currentIndex], noteStamps[currentIndex],abs(advancedDistance*travelDistance))
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
func transferData(times,innotes,curtime,inloop):
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
	loopinfo=  inloop
	print("BasslPLayer data Transfered")
