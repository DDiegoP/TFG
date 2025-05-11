extends Node2D

const LEFTX = -488
const RIGHTX = 495

#Bola sobre la que se aplica la fuerza
@export var ball : RigidBody2D
#Valor de fuerza que se aplica a la vola
@export var ballSpeed : float
#ReaSensorManager
@export var rsManager : ReaSensorManager

@export var textLabel : RichTextLabel

var catInteraction : Interaction
#Fuerza que se esta aplicando en la bola
var forceToApply : Vector2

var accelerForce
func _ready():
	catInteraction = rsManager.getInteractionAt(0)
	catInteraction.callable = Callable(self, "sendCatXToInteraction")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(accelerForce!= null):
		ball.apply_central_impulse(forceToApply+ Vector2(accelerForce.x, 0))

#Se cambia el vector de fuerza horizontal que se aplica a el nuevo valor
func changeForce(newForce):
	forceToApply = Vector2(newForce, 0)

#Al pulsar el boton izquierdo se añade fuerza a la izquierda
func _on_button_left_button_down():
	changeForce(-ballSpeed)

#Al levantar el boton izquierdo se añade elimina la fuerza
func _on_button_left_button_up():
	changeForce(0)

#Al pulsar el boton derecho se añade fuerza a la derecha
func _on_button_right_button_down():
	changeForce(ballSpeed)

#Al levantar el boton derecho se añade elimina la fuerza
func _on_button_right_button_up():
	changeForce(0)

func sendCatXToInteraction(interaction):
	var total
	
	accelerForce = interaction.sensorValue
	
	if(ball.position.x>=0):
		total = ball.position.x/RIGHTX
	else:
		total = -ball.position.x/LEFTX
	
	var shownVar = total*100
	
	if(shownVar>100):
		shownVar = 100
	if(shownVar<-100):
		shownVar = -100
	
	textLabel.text = str("[center]","%0.2f" % shownVar, "%", "[/center]")
	
	interaction.result = (total+1)/2
