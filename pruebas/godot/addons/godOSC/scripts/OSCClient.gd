@icon("res://addons/godOSC/images/OSCClient.svg")
class_name OSCClient
extends Node
## Client for sending Open Sound Control messages over UDP. Use one OSCClient per server you want to send to.

## The IP Address of the server to send to.
@export var  myip_address = "tu ip"
@export	var  other_ipaddress = "su ip" 
## The port to send to.
@export var port = 3003
var client = PacketPeerUDP.new()



func _ready():
	#get_deviceIPs()
	#connect_socket(port)
	pass

## Connect to an OSC server. Can only send to one OSC server at a time.
#func connect_socket ():
	##for address in IP.get_local_addresses():
	##IMPORTANTE ESTO ES PARA WINDOWS , COMPUTERNAME ES UNA VARIABLE DE WINDOWS 
	##PARA ANDROID HAY QUE CAMBIARLO	
	#SOPORTE PARA DNS
	#myip_address=IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)	
	#print(myip_address)	
	#client.set_dest_address(IP.resolve_hostname("tfg.net"), new_port)
	#print("created socket" + str(IP.resolve_hostname("tfg.net")) + "at port " + str (new_port))
	#client.set_broadcast_enabled(true)
	#client.set_dest_address("255.255.255.255", new_port)
		
		
func connect_socket(new_port = 3005):
	
	client.set_dest_address(other_ipaddress, new_port)
	##ip_address = client.get_packet_ip()
	##print("client ip " + ip_address)

func connect_socket_to_host(new_address = "127.0.0.1", new_port = 3005):
	
	client.set_dest_address(new_address, new_port)
	#le decimos al host nuestra direccion 
	var myaddress
	var androidname = []
	##IMPORTANTE ESTO ES PARA WINDOWS , COMPUTERNAME ES UNA VARIABLE DE WINDOWS 
	##PARA ANDROID HAY QUE CAMBIARLO
	if OS.get_name() == "Windows":
		for address in IP.get_local_addresses():
			myaddress=IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	if OS.get_name() == "Android":	
		#var output = [];
		#OS.execute("getprop",["net.hostname"],output) no est aseteado en todos los moviles :/
		#myaddress = IP.get_local_addresses()[6]#En android se supone qeu el wifi siempre es el primero 
		for address in IP.get_local_addresses():
			if address.begins_with("192.168.") or address.begins_with("10.") or (address.begins_with("172.") and int(address.split(".")[1]) >= 16 and int(address.split(".")[1]) <= 31):
				myaddress=address
	var packet = prepare_message("t/connect",[myaddress])
	print("sending message " + myaddress)
	client.put_packet(packet)
	##ip_address = client.get_packet_ip()
	##print("client ip " + ip_address)
	
	
func disconnect_socket_from_host(new_address :String, new_port : int, osc_address : String, args : Array):
	#Nos desconectamso del canal de efectos
	close_socket()
	#Mandmos un mensaje a ReaServer para informar de la desconexion
	client.set_dest_address(new_address, new_port)
	send_message(osc_address,args)
	#cerramos el socket 
	close_socket()
	pass
func close_socket():
	if client.is_socket_connected():
		client.close()

## Send an OSC message over UDP.
func prepare_message(osc_address : String, args : Array):
	var packet = PackedByteArray()
	
	packet.append_array(osc_address.to_ascii_buffer())
	
	packet.append(0)
	while fmod(packet.size(), 4):
		packet.append(0)
	
	packet.append(44)
	for arg in args:
		match typeof(arg):
			TYPE_INT:
				packet.append(105)
			TYPE_FLOAT:
				packet.append(102)
			TYPE_STRING:
				packet.append(115)
			TYPE_PACKED_BYTE_ARRAY:
				packet.append(98)
	
	packet.append(0)
	while fmod(packet.size(), 4):
		packet.append(0)
	
	for arg in args:
		var pack = PackedByteArray()
		match typeof(arg):
			TYPE_INT:
				pack.append_array([0, 0, 0, 0])
				pack.encode_s32(0, arg)
				pack.reverse()
			TYPE_FLOAT:
				pack.append_array([0, 0, 0, 0])
				pack.encode_float(0, arg)
				pack.reverse()
			TYPE_STRING:
				pack.append_array(arg.to_ascii_buffer())
				pack.append(0)
				while fmod(pack.size(), 4):
					pack.append(0)
			TYPE_PACKED_BYTE_ARRAY:
				pack.append_array(arg)
				while fmod(pack.size(), 4):
					pack.append(0)
		packet.append_array(pack)
	
	return packet

func send_message(osc_address : String, args : Array):
	var packet = prepare_message(osc_address, args)
	print("sending message " + str(args))
	client.put_packet(packet)
func send_broadcast_message(osc_address : String, args : Array):
	client.set_broadcast_enabled(true)
	var packet = prepare_message(osc_address, args)
	print("sending message " +osc_address)
	client.put_packet(packet)
	
func transfer_AppManagerData():
		client.set_dest_address(AppManager.curremtHostname, 3012)
		pass
		
	
	

