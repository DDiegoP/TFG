extends  OSCReceiver

@export var targetSelector : OptionButton
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var nTracks
	if target_server.incoming_messages.has(osc_address):
	#	parent.position.x = target_server.incoming_messages[osc_address][0]
		print(target_server.incoming_messages[osc_address])
		nTracks=target_server.incoming_messages[osc_address]
		target_server.incoming_messages.erase(osc_address)
		transferData(nTracks)
	pass

func transferData(data):
	for n in data[0]:
		name = "Track" + str(n)
		targetSelector.add_item(name,n)

	print("MIDI Controller Data Transfered")
pass
