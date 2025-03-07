
extends Node
#Singleton con info persistente
var curremtHostname : String = "s" 
var curremtHostport : int = 0 
var currentUserId : int =  1
var currentActionsPort = 3012
var currentMessages : = {} #evitamos perder mensajes en el cambio de escena 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

