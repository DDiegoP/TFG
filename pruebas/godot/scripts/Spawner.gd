extends Node

var timeStamp = 0
var currentIndex = 0
@export var bassStrings: Array[Marker2D] = []
@export var stringNotes = []
@export var noteStamps = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeStamp += delta
	if(noteStamps[currentIndex] < timeStamp):
		var chosen = randi_range(0,3)
		bassStrings[chosen].spawnNote(stringNotes[currentIndex])
		if(currentIndex + 1 == noteStamps.size() || currentIndex + 1 == stringNotes.size()):
			currentIndex = 0
			timeStamp = 0
		else:
			currentIndex += 1
	
