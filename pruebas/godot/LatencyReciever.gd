extends OSCReceiver


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target_server.incoming_messages.has(osc_address):
	#	parent.position.x = target_server.incoming_messages[osc_address][0]
		#print(target_server.incoming_messages.size())
		#print(target_server.incoming_messages)
		var sendtime
		var recievetime
		var latency
		sendtime =  target_server.incoming_messages[osc_address][0]
		recievetime = Time.get_unix_time_from_system()
		recievetime = int (recievetime)%1000000
		latency = recievetime - sendtime
		print ("Latency: " + str(float(latency)/1000))
		target_server.incoming_messages.erase(osc_address)
		
	pass
