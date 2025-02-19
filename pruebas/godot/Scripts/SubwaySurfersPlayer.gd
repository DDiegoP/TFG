extends RigidBody3D

@export var lerpSpeed = 10
@export var playerPositions: Array[Marker3D] = []
@export var leftButton : Button
@export var rightButton : Button
var targetPos
@export var currentIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	leftButton.connect("pressed",moveLeft)
	rightButton.connect("pressed",moveRight)
	targetPos = playerPositions[currentIndex]
	position = targetPos.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position.lerp(targetPos.global_position, delta*lerpSpeed)

func moveLeft():
	if(currentIndex > 0):
		currentIndex -= 1;
		targetPos = playerPositions[currentIndex];
		
func moveRight():
	if(currentIndex < playerPositions.size()-1):
		currentIndex += 1;
		targetPos = playerPositions[currentIndex];
