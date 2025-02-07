extends Node

@export var nota: PackedScene 
@export var button: Button
@export var key = ""
var rng = RandomNumberGenerator.new()
var randomSpawnTime = 0

func _ready():
	randomSpawnTime = rng.randf_range(5, 12)

func _process(delta):
	randomSpawnTime -= delta;
	if(randomSpawnTime<0):
		var newNote = nota.instantiate()
		add_child(newNote)
		newNote.key = key
		button.pressed.connect(newNote._on_boton_pressed)
		randomSpawnTime = rng.randf_range(5,15)
