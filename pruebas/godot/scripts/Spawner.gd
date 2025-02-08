extends Node

var counter = 0
@export var string1 : Marker2D
@export var string1Notes = []
@export var string2 : Marker2D
@export var string2Notes = []
@export var string3 : Marker2D
@export var string3Notes = []
@export var string4 : Marker2D
@export var string4Notes = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(string1Notes.size() > 0):
		string1.spawnNote(string1Notes[0])
		string1Notes.remove_at(0)
	if(string2Notes.size() > 0):
		string2.spawnNote(string2Notes[0])
		string2Notes.remove_at(0)
	if(string3Notes.size() > 0):
		string3.spawnNote(string3Notes[0])
		string3Notes.remove_at(0)
	if(string4Notes.size() > 0):
		string4.spawnNote(string4Notes[0])
		string4Notes.remove_at(0)
