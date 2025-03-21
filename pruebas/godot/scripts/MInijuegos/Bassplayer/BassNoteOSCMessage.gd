extends OSCMessage
@export var osc_address2 = "/example"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_boton_pressed():#pressed es todo el proceso 
	#target_client.send_message(osc_address, [str(osc_argument),str("O")])
	pass # Replace with function body.


func _on_boton_button_up():
	target_client.send_message(osc_address2, [str(osc_argument)]	)
	pass # Replace with function body.


func _on_boton_button_down():
	#print("a")
	target_client.send_message(osc_address, [str(osc_argument),str("On")]	)
	pass # Replace with function body.
