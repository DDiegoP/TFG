
--Acoplamos la info midi que nos llega por OSC si is permamnent esta a true no se borra al terminar
function translateMessage(msg,tracknum,ispermanent)
  
  --mitake = reaper.AddTakeToMediaItem(mit)
 
  --take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
 --reaper.ShowConsoleMsg(tostring(take).. "\n")
 --Los parametros de ese comando que demoniso son ?
 --take es el midi editor donde vamos a poner la nota
 -- El primer bool es si quieres que tras el comando esta nota se quede selecionada o no
 -- El siguiente bool es sel mute
 -- Los 2 numeros siguientes establencen en que momento temporal esmpieza y termina la nota
 -- El siguiente numero es el canal por el que se manda
 -- Luego el pitch
 -- Luego la velocidad
 -- Luego el isSort , ponerlo a false si vamos a mandar varias notas y luego llamar a la funcion midisort
 
  --reaper.MIDI_InsertNote(take,false,true,12,64,1,680,68,true)
 
  --ESTARIA GUAY  saber en que momento temporal estamos insertar la nota y avanzar
  
  -- Que la nota nos viene desde el pianito de godot , loquisimo esto 
  
  --msg = {}
  
  --Obtenemos acceso al take midi 
    track = reaper.GetTrack(0,tracknum)
    item = reaper.GetTrackMediaItem(track,0)
    take = reaper.GetActiveTake(item)
    isMidi = reaper.TakeIsMIDI(take)
    
     if isMidi then 
       reaper.ShowConsoleMsg("yay Midi Track")
    is_new, name, sec, cmd, rel, res, val, ctx = reaper.get_action_context()
   --traduciomos el mesaje para poner la nota
   -- msg.address = ctx:match("^osc:/([^:[]+)")
    
    --value_type, value = ctx:match(":([fs])=([^%]]+)")
       
     --  if value_type == "f" then
        --   msg.arg = tonumber(value)
      -- elseif value_type == "s" then
      --     msg.arg = value
      -- end
   
  --pitch = value
  pitch = 68
  lenght = 0.15 --duracio de la nota en segundos
  cur_pos = reaper.GetCursorPosition()
  --reaper.ShowConsoleMsg(tostring(cur_pos).."\n")
  
  cur_pos = reaper.GetCursorPosition()
  endpos =  reaper.MIDI_GetPPQPosFromProjTime(take , cur_pos+lenght)
  ppq = reaper.MIDI_GetPPQPosFromProjTime(take, cur_pos)
  endppq =  reaper.MIDI_GetProjTimeFromPPQPos(take,ppq + lenght)
  endppq =  reaper.MIDI_GetProjTimeFromPPQPos(take , endpos)
  reaper.MIDI_InsertNote(take,false,false,ppq,endpos,1,pitch,68,true)
  reaper.SetEditCurPos(endppq,true , true )
  if not ispermanent then 
  reaper.defer(removeAtEnd(take,1,endpos))
 -- while cur_pos < endpos do
  --   cur_pos = reaper.GetCursorPosition()
 -- end
 -- reaper.MIDI_DeleteNote(take,false,false,ppq,endpos,1,pitch,68,true)
  end
 -- reaper.MIDI_GetProjTimeFromPPQPos() 
 end
end

function removeAtEnd(take,index,endtime)
 if cur_pos < endtime then
     cur_pos = reaper.GetCursorPosition()
   end
   reaper.ShowConsoleMsg("a")
   reaper.MIDI_DeleteNote(take,index)
end


