extends OSCMessage


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$".." Accede al nodo padre que es el slider 
	#target_client.send_message(osc_address, [$"..".value])
	
	pass

#alguien se ocnfuncion con las signals de godot
#func _on_cube_1_slider_drag_ended(value_changed):
	##para que se mueva el cubo es esto
	#print("value changed to " + str($"..".value))
	##target_client.send_message(osc_address, [$"..".value])
	#target_client.send_message(osc_address, [str(osc_argument)]	)
	#pass # Replace with function body.



func _on_volumen_bajos_drag_ended(value_changed):
	print("value changed to " + str($"..".value))
	osc_argument =  str($"..".value)
	target_client.send_message(osc_address, [str(osc_argument)]	)
	pass # Replace with function body.
