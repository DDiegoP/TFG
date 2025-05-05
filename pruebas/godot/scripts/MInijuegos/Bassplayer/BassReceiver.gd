extends  OSCReceiver

@export var target_spawner : NoteSpawner
@export var osc_address2 := "/example"
@export var osc_address3 := "/example2"
@export var osc_address4 := "/example3"
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ctime
	var notes
	var times
	var loop = []
	if target_server.incoming_messages.has(osc_address):
	#	parent.position.x = target_server.incoming_messages[osc_address][0]
		print(target_server.incoming_messages[osc_address])
		notes=target_server.incoming_messages[osc_address]
		target_server.incoming_messages.erase(osc_address)
	if target_server.incoming_messages.has(osc_address2):
		times=target_server.incoming_messages[osc_address2]
		#le pasamos la info al spawner de notas 
		#cuando esto termina consumimos el mensaje
		target_server.incoming_messages.erase(osc_address2)
	if target_server.incoming_messages.has(osc_address4):
		loop.append( target_server.incoming_messages[osc_address4][0])
		loop.append(target_server.incoming_messages[osc_address4][1])	
	if target_server.incoming_messages.has(osc_address3):
		ctime=target_server.incoming_messages[osc_address3][0]
		target_server.incoming_messages.erase(osc_address3)
		target_spawner.transferData(times,notes,ctime,loop)
		
	
	pass
