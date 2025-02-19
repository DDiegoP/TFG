extends Node

var timeStamp = 0
var currentIndex = 0
@export var guitarStrings: Array[Marker3D] = []
@export var stringNotes = []
@export var noteStamps = []
@export var obstacle : PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeStamp += delta
	if(noteStamps[currentIndex] < timeStamp):
		var chosen = randi_range(0,5)
		spawnNote(guitarStrings[chosen],stringNotes[currentIndex])
		if(currentIndex + 1 == noteStamps.size() || currentIndex + 1 == stringNotes.size()):
			currentIndex = 0
			timeStamp = 0
		else:
			currentIndex += 1
	

func spawnNote(position, noteToSpawn):
	var newObstacle = obstacle.instantiate()
	position.add_child(newObstacle)
	newObstacle.key = noteToSpawn
