extends Node

@export var scene_client : OSCClient
@export var scene_server : OSCServer

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_client.transfer_AppManagerData()
	scene_server.transfer_AppManagerData()
	pass # Replace with function body.	scene_client.transfer_AppManagerData()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
