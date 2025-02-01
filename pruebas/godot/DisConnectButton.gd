extends OSCMessage


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	
	pass # Replace with function body.


## El puerto donde esta rea server en el pc es el 3000 !
func _on_dis_connect_button_pressed():
	osc_argument = AppManager.currentUserId
	#target_client.send_message(osc_address, [float(osc_argument)]	)
	target_client.disconnect_socket_from_host(AppManager.curremtHostname,3000,osc_address, [float(osc_argument)])
	pass # Replace with function body.
