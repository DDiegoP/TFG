extends Node

const TOP_VOL_VALUE = 0.8

const TRACK_INIT_INDEX = 5

@export var rsManager : ReaSensorManager

@export var launcher : StaticBody2D

@export var targets : Array[Node2D]

var interactions : Array[Interaction]

var furthestPosValue

func _ready():
	interactions = rsManager.getInteractions()
	furthestPosValue = (launcher.global_position - targets[3].position).length()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for interaction in interactions:
		calculateInteractionValues(interaction)
	
func calculateInteractionValues(interaction):
	interaction.result = TOP_VOL_VALUE - (launcher.global_position - targets[interaction.trackNum - TRACK_INIT_INDEX].position).length() / furthestPosValue
