# Control system for interactive audiovisual installations

**Index**   
1. [Demo Project](#id1)
2. [Instalation Guide](#id2)
3. [Custom App Development](#id3)
## Demo Project<a name="id1"></a>
This repository contains a sample project. This particular demo consists of a mobile app that will allow the user to interact directly with a Reaper project that is provided. The conection will be handled via the OSC protocol. This mobile app contains 4 minigames and a very basic MIDI controller that you can hook up to your Reaper project. The sample Reaper project is a short Blues piece structured specifically to change as it recieves user input from the mobile app.


[![Watch the video](https://img.youtube.com/vi/GxqUUZo5mSc/maxresdefault.jpg)](https://youtu.be/GxqUUZo5mSc)

## Instalation Guide<a name="id2"></a>
In order to try out the demo project you will need follow a series of simple steps:

* Copy the .APK file located in the "DEMO" folder to your mobile device.

* Open our portable version of reaper by clicking on "PortableReaper/reaper.exe"

* Open the "JazzKats.rpp" file with that version of reaper
  
* Go to Options>Preferences>Control/OSC/web> and click Add. Select local port and type 3012. Make sure you tick the "Allow binding messages to REAPER actions " checkbox to enable a port for our OSC messages to go through.
  
* Click on actions and execute "JazzKatsServer.lua"
  
* A console will show up in reaper containing the IP address you have to type on the mobile app.

[![Watch the video](https://img.youtube.com/vi/9uLZ6GbC18Y/maxresdefault.jpg)](https://youtu.be/9uLZ6GbC18Y)

We can´t directly distribute the VST plug ins that we used to create our song but all of them are freely available online. To get your Reaper project to sound like ours you will need to install: 
* [Kontak 7 komplete start](https://www.native-instruments.com/es/products/komplete/bundles/komplete-start/)
* [stochas probabilistic sequencer](https://stochas.org/)

## Custom App Development <a name= "id3"></a>

To develop your own application you can use all of the tools ans scripts we developed for our own project. It is important to keep in mind that all our binaries were compiled for Reaper v7.25 - October 14 2024. Future versions may need and updated version of the LuaSocketCore.dll.

We developed our mobile app in the Godot Engine and created some scripts that you may find useful: 
* ReaSensorManager.gd: This script offers a layer of abstration to map inputs from sensors to OSC messages easily.

* AppManager.gd: Stores all information related to networking, here you can change the port from which the communication is carried on.

We developed some utility scripts for Reaper you may find helpful: 
* ReaServer.lua: You can use inheritance to create a particular script for your project and let ReaServer handle user slots and connections while you override the OnCOnnect and OnDistconnect methods for any particular purpose you may need.
* OSCToMidi.lua: This script can input MIDI information directly into a specified MIDI channel or a specified MIDI take.
* Miditoarray.lua: This script can translate MIDI takes into information that can be sent over OSC in case you want to try and create your own rythm game.

