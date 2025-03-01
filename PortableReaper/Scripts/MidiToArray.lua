--Script que traduce una pista de midi ya compuesta para poder pasarla por OSC
tracknum = 0 -- que pista queremos traducir 
codifiedTrack = {} -- array de pares (nota, tiempo )

--example = {23,4}
--codifiedTrack[1]= example
--reaper.ShowConsoleMsg(tostring( codifiedTrack[1][1])) funciona :)
function translateTrack(t)
  -- primero pillamos nuestro midi item de reaper 
  track = reaper.GetTrack(0,tracknum)

  -- obtenemos el midi item 

  item = reaper.GetTrackMediaItem(track,0)

  -- dentro del item obtenemos la take ocn las notas y eso
  take = reaper.GetActiveTake(item)
  isMidi = reaper.TakeIsMIDI(take)

  if isMidi then 
    reaper.ShowConsoleMsg("yay Midi Track")
  -- Obtenemos el numero de notas de la midi track 
   nNotes = reaper.MIDI_CountEvts(take)
  --reaper.ShowConsoleMsg(tostring(nNotes))
  --Obtenemos la informacion que necesitamos de cada nota
  for i=1,nNotes do
    --reaper.ShowConsoleMsg(tostring(i))
    -- PPQ son los Pulses Per Quarternote y ser anuestra manera de medir el tiempo  
    --https://www.drumthrash.com/help-guide/understanding-pulses-per-quarter-note.html#:~:text=The%20term%20pulses%20per%20quarter,as%20MIDI%20sequencers%20and%20synthesizers.
   local retval, selected, muted, startppqpos, endppqpos, chan, pitch,vel 
       = reaper.MIDI_GetNote(take, i)
          reaper.ShowConsoleMsg(tostring(startppqpos))
          reaper.ShowConsoleMsg("S ")
          reaper.ShowConsoleMsg(tostring((endppqpos)))
          reaper.ShowConsoleMsg("E ")
    -- Pitch es la nota y va desde 0 a 128 
        notepair = {startppqpos,pitch}
        codifiedTrack[i] = notepair
    -- https://inspiredacoustics.com/en/MIDI_note_numbers_and_center_frequencies
    end
 -- reaper.MIDI_GetNote()
  --reaper.ShowConsoleMsg(tostring(codifiedTrack[1][2]))
  end
  return codifiedTrack
end
--reaper.ShowConsoleMsg(tostring(take))
