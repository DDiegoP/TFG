extends Node

#Prefab de la nota
@export var nota: PackedScene 
#Boton del carril
@export var button: Button
@export var texture : Texture

# Spawnea la nota en el punto de spawn y conecta la senial del boton a la funcion de la nota
func spawnNote(note, noteStamp):
	var newNote = nota.instantiate()
	add_child(newNote)
	newNote.targetTime = noteStamp
	newNote.key = note
	newNote.setAspect(texture)
	button.pressed.connect(newNote._on_boton_pressed)
