extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	#self.connect("value_changed", self, "_process")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_changed(v):
	print("value changed to " + str(v))
func value_changed():
	print("value changed to " + str(12))
