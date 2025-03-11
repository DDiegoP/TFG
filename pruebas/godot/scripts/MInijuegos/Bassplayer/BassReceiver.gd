extends  OSCReceiver

@export var target_spawner : NoteSpawner
@export var osc_address2 := "/example"
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var notes
	var times
	if target_server.incoming_messages.has(osc_address):
	#	parent.position.x = target_server.incoming_messages[osc_address][0]
		print(target_server.incoming_messages[osc_address])
		notes=target_server.incoming_messages[osc_address]
		target_server.incoming_messages.erase(osc_address)
	if target_server.incoming_messages.has(osc_address2):
		times=target_server.incoming_messages[osc_address2]
		
		target_spawner.transferData(times,notes)
		#le pasamos la info al spawner de notas 
		#cuando esto termina consumimos el mensaje
		target_server.incoming_messages.erase(osc_address2)
	
	pass
