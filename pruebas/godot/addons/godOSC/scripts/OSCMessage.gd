@icon("res://addons/godOSC/images/OSCMessage.svg")
class_name OSCMessage
extends Node
## Convenience class for organizing an OSC message. Used with an OSCClient. To add your own code, extend the script attached to the OSCReceiver you create by right clicking and "extend script"

## The client to send the OSC message with
@export var target_client : OSCClient

## The OSC address to send to
@export var osc_address := "/example"
##Para reaper solo se puede leer desde reascript el primer floa to el primer string
@export var osc_argument = "argument"
