extends OSCMessage


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_item_selected(index):
	osc_argument=index
	target_client.send_message(osc_address, [str(osc_argument)]	)
	pass # Replace with function body.
