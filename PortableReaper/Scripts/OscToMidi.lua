
--Acoplamos la info midi que nos llega por OSC si is permamnent esta a true no se borra al terminar

tracknum = 0 --Debe ser global para poder usar la funcion en defer

function translateMessage()
  
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
  
    msg = {}
  
  --Obtenemos acceso al take midi 
    track = reaper.GetTrack(0,tracknum)
    item = reaper.GetTrackMediaItem(track,0)
    take = reaper.GetActiveTake(item)
    isMidi = reaper.TakeIsMIDI(take)
    
     if isMidi then 
       reaper.ShowConsoleMsg("yay Midi Track")
    is_new, name, sec, cmd, rel, res, val, ctx = reaper.get_action_context()
   --traduciomos el mesaje para poner la nota
    msg.address = ctx:match("^osc:/([^:[]+)")
    
    value_type, value = ctx:match(":([fs])=([^%]]+)")
       
       if value_type == "f" then
          msg.arg = tonumber(value)
       elseif value_type == "s" then
          msg.arg = value
       end
   
  --pitch = value
  pitch = value
  --lenght = 0.15 --duracio de la nota en segundos
  lenght = 0.45
  --cur_pos = reaper.GetCursorPosition()
  cur_pos = reaper.GetPlayPosition()
  --reaper.ShowConsoleMsg(tostring(cur_pos).."\n")
  --cur_pos = reaper.GetCursorPosition()
  endpos =  reaper.MIDI_GetPPQPosFromProjTime(take , cur_pos+lenght)
  ppq = reaper.MIDI_GetPPQPosFromProjTime(take, cur_pos)
  endppq =  reaper.MIDI_GetProjTimeFromPPQPos(take,ppq + lenght)
  endppq =  reaper.MIDI_GetProjTimeFromPPQPos(take , endpos)
  reaper.MIDI_InsertNote(take,false,false,ppq,endpos,1,pitch,68,true)
 -- reaper.SetEditCurPos(endppq,true , true )
  reaper.defer(removeFirst)
 -- if not ispermanent then 
 -- reaper.defer(removeAtEnd(take,0,endpos))
 -- while cur_pos < endpos do
  --   cur_pos = reaper.GetCursorPosition()
 -- end
 -- reaper.MIDI_DeleteNote(take,false,false,ppq,endpos,1,pitch,68,true)
  --end
 -- reaper.MIDI_GetProjTimeFromPPQPos() 
 end
end
--Si haces defer no puedes tener argumentos XD
function removeAtEnd(take,index,endtime)
  playhead_pos = reaper.GetPlayPosition()
  
  if playhead_pos < reaper.MIDI_GetProjTimeFromPPQPos( endtime) then  
    --reaper.ShowConsoleMsg("a")
   reaper.MIDI_DeleteNote(take,index)
   end
   
end

-- La funcion para defer bien hecha
function removeFirst ()
  -- si no esta vacia vemos si la primera nota ya se ha acabado
  pista = reaper.GetTrack(0,tracknum)
  objeto = reaper.GetTrackMediaItem(pista,0)
  toma = reaper.GetActiveTake(objeto)
  nNotes = reaper.MIDI_CountEvts(toma)
  l = reaper.GetMediaItemInfo_Value(objeto, "D_LENGTH")
  
  
  if nNotes > 0 then
   playhead_pos = reaper.GetPlayPosition()
   local retval, selected, muted, startppqpos, endppqpos, chan, pitch,vel 
          = reaper.MIDI_GetNote(toma,0)
   
     if playhead_pos - 0.25  > reaper.MIDI_GetProjTimeFromPPQPos(toma,endppqpos)    then  
     --reaper.ShowConsoleMsg("a")
     reaper.MIDI_DeleteNote(toma,0) 
    
     end
    -- if  playhead_pos >= l - 0.0016 then
     if  playhead_pos <=  0.25 then 
      for i=0,nNotes-1 do --El array de notas midi de reaper empieza en 0 tambien
      reaper.MIDI_DeleteNote(toma,0) 
      end
     end
     reaper.defer(removeFirst)
  end
  
  
  
end
--0x90 note on , 0x80 note off
function stuffMidiChanel(cc,note)
    reaper.StuffMIDIMessage(0,cc,note,67)

end
