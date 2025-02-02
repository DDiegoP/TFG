--Primero necesitamos sacar el argumento del mensaje
 -- a = 12345
 -- b = 100
 -- c = a%b
 -- reaper.ShowConsoleMsg(c)
  msg = {}
 is_new, name, sec, cmd, rel, res, val, ctx = reaper.get_action_context()
   msg.address = ctx:match("^osc:/([^:[]+)")
    
    value_type, value = ctx:match(":([fs])=([^%]]+)")
       
       if value_type == "f" then
           msg.arg = tonumber(value)
       elseif value_type == "s" then
           msg.arg = value
       end
--reaper.ShowConsoleMsg( msg.arg)
--me llegan las 2 ultimas cifras + 4 decimales en segundos
recievetime = os.time()
reaper.ShowConsoleMsg(recievetime )

-- nos quedamos con las mismas cifras que godot S
--recievetime = recievetime*10000
p = 1000000
dt = recievetime%p
reaper.ShowConsoleMsg("Recieve Time = " )
reaper.ShowConsoleMsg(dt )
latency = dt - msg.arg
reaper.ShowConsoleMsg("LATENCY = " )
reaper.ShowConsoleMsg(latency/1000) -- son en realidad milisegundos
-- ahora para comprobar la latencia desde reaper a godot mandamos un mensaje desde aqui 

local opsys = reaper.GetOS()
local extension 
if opsys:match('Win') then
  extension = 'dll'
else -- Linux and Macos
  extension = 'so'
end

local info = debug.getinfo(1, 'S');
local script_path = info.source:match[[^@?(.*[\/])[^\/]-$]];
package.cpath = package.cpath .. ";" .. script_path .. "/socket module/?."..extension  -- Add current folder/socket module for looking at .dll (need for loading basic luasocket)
package.path = package.path .. ";" .. script_path .. "/socket module/?.lua" -- Add current folder/socket module for looking at .lua ( Only need for loading the other functions packages lua osc.lua, url.lua etc... You can change those files path and update this line)ssssssssssssssssssssssssssssssssssss

-- Functions
function print(...) 
  local t = {}
  for i, v in ipairs( { ... } ) do
      t[i] = tostring( v )
  end
  reaper.ShowConsoleMsg( table.concat( t, " " ) .. "\n" )
end



local socket = require('socket.core')
local osc = require('osc')

local udp1 = assert(socket.udp())
local udp = assert(socket.udp())
--assert(udp:setsockname("127.0.0.1",9004)) -- Set IP and PORT
assert(udp1:setpeername("177.44.4.1",3009)) -- Informacion aleatoria es solo para inicializarlo
s,n = udp1:getsockname()--tras inicializarlo nos puede dar la IP de este oredenador :)
--reaper.ShowConsoleMsg(s)
--Hemos establecido que el servidor de nuestro programa estara en el puerto 3004:
assert(udp:setsockname(s,3002))
--udp:settimeout(0.0001) -- Dont forget to set a low timeout! udp:receive block until have a message or timeout. values like (1) will make REAPER laggy.

sendtime = os.time()
st = sendtime%p
local msg1 = osc.encode('/latency', st, 3.14, 'hello world!')
udp:sendto(msg1, "192.168.1.56",3003)
