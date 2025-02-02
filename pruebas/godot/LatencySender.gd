extends OSCMessage


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_check_latency_button_pressed():
	#timestamp in seconds
	osc_argument = Time.get_unix_time_from_system()
	#solo me interesan los 4 ultimos digitos que son hasta milisegundos de precision
	print(osc_argument)
	
	osc_argument = osc_argument 
	#1738517946
	#solo puedo codificar hasta 32 bits :T paso las ciframs que me importan 
	#el equivalente 100.x ms
	osc_argument = int (osc_argument)%1000000
	target_client.send_message(osc_address, [float(osc_argument)])
	pass # Replace with function body.
