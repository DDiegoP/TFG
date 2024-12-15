extends Node2D
@export var scene_client : OSCClient

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_client.transfer_AppManagerData()
	pass # Replace with function body.	scene_client.transfer_AppManagerData()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
