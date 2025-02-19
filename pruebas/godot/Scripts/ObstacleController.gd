extends RigidBody3D

const SPEED = 100
const DEATH_ZONE = 0
var key = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector3(0, 0, delta * SPEED))
	if (global_position.z > DEATH_ZONE):
		queue_free();
