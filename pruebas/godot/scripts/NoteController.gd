extends Area2D

const SPEED = 100
const DEATH_ZONE = 800
var key = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += delta * SPEED
	if (position.y> DEATH_ZONE):
		queue_free();
	


func _on_boton_pressed():
	if(get_overlapping_areas().size()>0):
		print_debug(key)
		queue_free();
