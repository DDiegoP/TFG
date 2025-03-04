extends Marker2D

@export var nota : PackedScene
@export var cat : RigidBody2D

# Called when the node enters the scene tree for the first time.
func spawnNote(note):
	var newNote = nota.instantiate()
	add_child(newNote)
	newNote.key = note
	newNote.ball = cat
