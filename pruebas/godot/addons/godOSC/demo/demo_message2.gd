extends OSCMessage


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#target_client.send_message(osc_address, [$"..".value])
	#target_client.send_message(osc_address, [])
	pass


func _on_cube_2_slider_drag_ended(value_changed):
	target_client.send_message(osc_address, [])
	
