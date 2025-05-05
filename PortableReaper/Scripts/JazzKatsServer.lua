--Agregamos los paths de donde a buscar las dependencias
local Info       = debug.getinfo (1, 'S');
local ScriptPath = Info.source:match[[^@?(.*[\/])[^\/]-$]];
package.path     = ScriptPath .. '?.lua;'  .. package.path;--Que realmente es donde estamos pero no busca aqui por defecto

require("ReaServer") --Usamos nuestra clase de utilidad y la modificamos con la funcionaliad especifica de nuestro jeugo
--Esto ejecuta todo el set up y nos imprime la ip en consola y eso :)
require("MidiToArray")
function onConnect(a) -- override de que pasa en mi juego en especifico cuando se concecta alguien
 -- reaper.ShowConsoleMsg("b")
  if a == 2 then
    reaper.ShowConsoleMsg("bass player connected")
    --Se conecto el que toca el bajo le mandamos a godot nuestra linea de bajo
    basslineTimes,basslineNotes = translateTrack(0)
    --Los arrays normales empiezan en 0 pero las tablas de lua en 1 :)
    table.insert(basslineNotes,1,basslineNotes[0])
    table.insert(basslineTimes,1,basslineTimes[0]) 
    --reaper.ShowConsoleMsg(bassline[1])
    --por que momento de la pieza estamos tambien es informacion util 
    local msg =osc.encodeArray("t/BassLineTime",basslineTimes) 
    udp:sendto(msg,userips[2],userServerPort)
    
    
    local msg =osc.encodeArray("t/BassLineNote",basslineNotes) 
    reaper.ShowConsoleMsg(tostring(msg))
    udp:sendto(msg,userips[2],userServerPort)
    reaper.ShowConsoleMsg(tostring(basslineNotes[0]))
    currentTime = reaper.GetPlayPosition()
    local msg = osc.encode("t/CurrentTime",currentTime)
    udp:sendto(msg,userips[2],userServerPort)
    --y por ultimo como esta pieza tiene un bucle necesitamos mandar tambien informacion dle mismo
    loopstart,loopend = reaper.GetSet_LoopTimeRange(false,true,0,0,true)
    local msg = osc.encode("t/loopInfo",loopstart,loopend)
    
    udp:sendto(msg,userips[2],userServerPort)

  elseif a == 4 then
    reaper.ShowConsoleMsg("MiniMIDIController connected")
    ntracks = reaper.CountTracks(0)
    local msg = osc.encode("t/NumOfTracks",ntracks)
    udp:sendto(msg,userips[4],userServerPort)
  
  end
end

--Nuestro Juego es para 4 jugadores asi qeu especificamos 4 slots de usuario
maxusers = 5
createUserSlots()
setUp()



a = getUserIP(1)
reaper.ShowConsoleMsg(a)

Main()
