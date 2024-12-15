--Este script cambia el volumen de las pistas de bajos
--Primero necesitamos sacar el argumento del mensaje
  
  msg = {}
 is_new, name, sec, cmd, rel, res, val, ctx = reaper.get_action_context()
   msg.address = ctx:match("^osc:/([^:[]+)")
    
    value_type, value = ctx:match(":([fs])=([^%]]+)")
       
       if value_type == "f" then
           msg.arg = tonumber(value)
       elseif value_type == "s" then
           msg.arg = value
       end
--Los bajos estan en las pistas 2 , 3 y 5 (empiezan en 0 como un array)
--vol debe rondar entre 0 y 2
reaper.ShowConsoleMsg(msg.arg)
vol =msg.arg
track = reaper.GetTrack(0,1)
reaper.SetTrackUIVolume(track,vol,false,true,0)
track = reaper.GetTrack(0,2)
reaper.SetTrackUIVolume(track,vol,false,true,0)
track = reaper.GetTrack(0,4)
reaper.SetTrackUIVolume(track,vol,false,true,0)



