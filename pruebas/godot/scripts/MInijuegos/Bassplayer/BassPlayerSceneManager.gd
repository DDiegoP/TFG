extends Node2D

@export var scene_client : OSCClient
@export var scene_server : OSCServer

@export var oscEndMessage : String

var phone := OS.has_feature("mobile")

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_client.transfer_AppManagerData()
	scene_server.transfer_AppManagerData()

func _notification(what):
	if phone:
		if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			endConnection()
	else:
		if what == NOTIFICATION_WM_CLOSE_REQUEST:
			endConnection()
			
func endConnection():
	print("Discconnect")
	scene_client.terminateConnection("t/disconnect")
	get_tree().quit()

