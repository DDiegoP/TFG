extends OSCMessage

#@export var broadcast_address = "255.255.255.255"
# Called when the node enters the scene tree for the first time.
func _ready():
	#var a : float  =  123542525%10000 no puedes pillar el resto de un float ?!  
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	
	print("Me conecto wiii" + str($"..".text))
	#el ordenador al que nos vamos a conectar
	AppManager.curremtHostname=$"..".text
	AppManager.curremtHostport = 3000
	target_client.connect_socket_to_host(AppManager.curremtHostname,3000)
	
	##target_client.send_broadcast_message((broadcast_address), [str(osc_argument)]	)
	pass # Replace with function body.
