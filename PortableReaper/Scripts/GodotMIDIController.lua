--Reaper almacena la track seleccionada
--Los componentes de la ui de godot no tienen por que saber a donde mandan que
--Dichoso OSC en reaper con su unico argumento utilizable.

--Definimos funciones 

function selectTrack(nt)
-- primero tenemos qeu de seleccionar la que ya está seleccionada
    track = reaper.GetSelectedTrack(0,0)
   reaper.ShowConsoleMsg(tostring(track))
  if  track == nil  then
  track = reaper.GetTrack(0,nt)
  reaper.SetTrackSelected(track,true)
  else
 
   reaper.SetTrackSelected(track,false)
   track = reaper.GetTrack(0,nt)
   reaper.SetTrackSelected(track,true)
  end
end
  

function setVolume(nv)
  track = reaper.GetSelectedTrack(0,0)
 
 -- reaper.ShowConsoleMsg(track)
  reaper.SetTrackUIVolume(track,nv,false,true,0)
end

function setPan(np)
  track = reaper.GetSelectedTrack(0,0)
  reaper.SetTrackUIPan(track,np,false,true,1)
end

function clearMidiTrack()
  pista = reaper.GetSelectedTrack(0,0)
  objeto = reaper.GetTrackMediaItem(pista,0)
  toma = reaper.GetActiveTake(objeto)
  nNotes = reaper.MIDI_CountEvts(toma)
  for i=0,nNotes-1 do --El array de notas midi de reaper empieza en 0 tambien
  reaper.MIDI_DeleteNote(toma,0) 
  end
  reaper.SetEditCurPos(0,true , true )

end
function insertMidi(note)
  pista = reaper.GetSelectedTrack(0,0)
  objeto = reaper.GetTrackMediaItem(pista,0)
  take = reaper.GetActiveTake(objeto)
  pitch = note
  --lenght = 0.15 --duracio de la nota en segundos
  lenght = 0.45
  cur_pos = reaper.GetCursorPosition()
  reaper.ShowConsoleMsg(tostring(cur_pos))
  cur_pos = reaper.GetCursorPosition()
  endpos =  reaper.MIDI_GetPPQPosFromProjTime(take , cur_pos+lenght)
  ppq = reaper.MIDI_GetPPQPosFromProjTime(take, cur_pos)
  endppq =  reaper.MIDI_GetProjTimeFromPPQPos(take,ppq + lenght)
  endppq =  reaper.MIDI_GetProjTimeFromPPQPos(take , endpos)
  reaper.MIDI_InsertNote(take,false,false,ppq,endpos,1,pitch,68,true)
  reaper.SetEditCurPos(endppq,true , true )
  
end
--Extraemos la info del mensaje y vempos que accion
--va a realizar el controlador
   msg = {}
   is_new, name, sec, cmd, rel, res, val, ctx = reaper.get_action_context()
   --reaper.ShowConsoleMsg(tostring(ctx))
   --traduciomos el mesaje para obtener el valor y tipo de evento
    msg.address = ctx:match("^osc:/([^:[]+)")
    --Obtenemos la address sin "/"
    value_type, value = ctx:match(":([fs])=([^%]]+)")
      
          
          if value_type == "f" then
             msg.arg = tonumber(value)
          elseif value_type == "s" then
             msg.arg = value
             msg.arg = value
          end
    reaper.ShowConsoleMsg(tostring(value))
    if msg.address == "SelectTrack" then 
     selectTrack(value)
    end
    if msg.address == "SetVolume" then 
    setVolume(value)
    end
    if msg.address == "SetPan" then 
    setPan(value)
    end
    if msg.address == "midiP" then
    insertMidi(value)
    end
    if msg.address == "clearMidi" then
    clearMidiTrack()
    end
    
