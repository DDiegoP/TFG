-- @noindex
-- Load the socket module
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

-- Get socket and osc modules
local socket = require('socket.core')
local osc = require('osc')

-- Get UDP
local udp1 = assert(socket.udp())
local udp = assert(socket.udp())
--assert(udp:setsockname("127.0.0.1",9004)) -- Set IP and PORT
assert(udp1:setpeername("177.44.4.1",3004)) -- Informacion aleatoria es solo para inicializarlo
s,n = udp1:getsockname()--tras inicializarlo nos puede dar la IP de este oredenador :)
reaper.ShowConsoleMsg(s)
--Hemos establecido que el servidor de nuestro programa estara en el puerto 3004:
assert(udp:setsockname(s,3000))
udp:settimeout(0.0001) -- Dont forget to set a low timeout! udp:receive block until have a message or timeout. values like (1) will make REAPER laggy.

local msg1 = osc.encode('/t connect', 666, 3.14, 'hello world!')
udp:sendto(msg1, "192.168.1.56",3003)
users = {} --el servidor gestiona los slpts de usuarios disponibles 
maxusers = 2 --cuantos usuarios simultaneos podemos gestionar

for i = 0, maxusers do
  users[i]=i
end
reaper.ShowConsoleMsg(#users)-- # es el lenght opeerator en lua :0
local function Main()
 for address, values in osc.enumReceive(udp) do
     --obtenemos los argumentos una vez por mensaje y dependiendo del tipo de mensaje gestionamos.    
     args = {}
     i = 0
     for k ,v in ipairs(values) do
      args[i] = v
      i = i+1
     end 
     --Gestionamos los distintos tipos de mensajes :
     --Conexion de un usuario nuevo : 
      if address == 't/connect' then 
      u = math.random(0,#users -1)
   
      local msg1 = osc.encode('/t connect', users[u], 3.14, 'hello world!')
      udp:sendto(msg1,args[0],3003)
      table.remove(users,u+1) --ese slot de usuario ya no esta disponible
      print('currenusers',users)
      end
     
      --Desconexion de un usuario 
      --nos envia su token y lo devolvemos a la lista
      if address == 't/disconnect' then
      table.insert(users,args[0])
      a = args[0]
      reaper.ShowConsoleMsg('user disconected')
      reaper.ShowConsoleMsg(args[0])
      end
     -- print('address: ', address)
      --print('This message haves '..#values..' values:')
      for k, v in ipairs(values) do
        --print('    ', v)
      end
    end
    reaper.defer(Main) -- Se usa defer para que la funcion siga ejecutandose y procesando input similar a runloop()
    
end
--- Script: 
Main()

