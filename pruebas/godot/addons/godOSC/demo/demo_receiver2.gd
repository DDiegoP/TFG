extends OSCReceiver


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if target_server.incoming_messages.has(osc_address):
		parent.scale = Vector2(1,1) * target_server.incoming_messages[osc_address][0]
	pass


func _on_cube_2_slider_drag_ended(value_changed):
	pass # Replace with function body.
