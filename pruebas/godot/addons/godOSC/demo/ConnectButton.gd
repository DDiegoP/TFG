extends OSCMessage

@export var requestType = "t/connect"
@export var targetPort = 3000

func _on_pressed():
	#el ordenador al que nos vamos a conectar
	AppManager.currentHostName=$"..".text
	AppManager.currentHostPort = targetPort
	target_client.connect_socket_to_host(AppManager.currentHostName, targetPort, requestType)
