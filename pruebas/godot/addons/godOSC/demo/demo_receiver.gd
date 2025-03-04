extends OSCReceiver


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(target_server.incoming_messages.has(osc_address))
	if target_server.incoming_messages.has(osc_address):
	#	parent.position.x = target_server.incoming_messages[osc_address][0]
		print(target_server.incoming_messages)
		#El host nos dara una slot de usuario libre y dependiendo de cual nos toque cargamso una escena u otra
		var sceneid 
		sceneid =  target_server.incoming_messages[osc_address][0]
		AppManager.currentUserId = sceneid
		#sceneid =  1
		print(sceneid)
		match  sceneid:
			0:
				get_tree().change_scene_to_file("res://ESCENAUSER1.tscn")
			1:
				get_tree().change_scene_to_file("res://ESCENAUSER2.tscn")
			2:
				get_tree().change_scene_to_file("res://Minijuegos/MinijuegoPianoTiles.tscn")
	
	pass
