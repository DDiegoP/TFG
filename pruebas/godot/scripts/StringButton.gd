extends Node

@export var nota: PackedScene 
@export var button: Button
@export var key = ""


func spawnNote(note):
	var newNote = nota.instantiate()
	add_child(newNote)
	newNote.key = note
	button.pressed.connect(newNote._on_boton_pressed)
