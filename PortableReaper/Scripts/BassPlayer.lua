--Agregamos los paths de donde a buscar las dependencias 
local Info       = debug.getinfo (1, 'S');
local ScriptPath = Info.source:match[[^@?(.*[\/])[^\/]-$]];
package.path     = ScriptPath .. '?.lua;'  .. package.path;--Que realmente es donde estamos pero no busca aqui por defecto

require("OscToMidi")
--pista en la que esta el item que queremos escribimos 
tracknum=1 --A que los arrays empiezan en 1 pero las tracks de reaper empiezan en 0
--accedemos al poryecto actual v 
prj = reaper.EnumProjects(-1)    
reaper.ShowConsoleMsg(reaper.GetPlayPosition())
 
--translateMessage()
   msg = {}
   is_new, name, sec, cmd, rel, res, val, ctx = reaper.get_action_context()
   --reaper.ShowConsoleMsg(tostring(ctx))
   --traduciomos el mesaje para obtener el  pitch y el tipo de evento
    msg.address = ctx:match("^osc:/([^:[]+)")
   
    if msg.address == "BassNoteOn" then 
      evt=0x90
    end
    if msg.address == "BassNoteOff" then
      evt=0x80
    end
    
    
    value_type, value = ctx:match(":([fs])=([^%]]+)")
      
          
          if value_type == "f" then
             msg.arg = tonumber(value)
          elseif value_type == "s" then
             msg.arg = value
             msg.arg = value
          end
       pitch = value
       
stuffMidiChanel(evt,pitch)
