extends Node

#Singleton con info persistente
var currentHostName : String = "s" 
var currentHostPort : int = 0 
var currentUserId : int =  1
var currentActionsPort = 3012
#Evitamos perder mensajes en el cambio de escena 
var currentMessages : = {} 
