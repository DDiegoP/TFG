extends StaticBody2D

@export var key : String

func _on_ball_body_entered(body):
	if(body == get_node(".") && body.collision_layer == collision_layer):
		print(key)
