-- @noindex
-- Cargaremos nuestro modulo de lua socket
local opsys = reaper.GetOS()
local extension 
if opsys:match('Win') then
  extension = 'dll'
else -- Linux and Macos
  extension = 'so'
end

local info = debug.getinfo(1, 'S');
local script_path = info.source:match[[^@?(.*[\/])[^\/]-$]];
package.cpath = package.cpath .. ";" .. script_path .. "/socket module/?."..extension  -- En nuestra carpeta actual + "/socket module"  encontramos la  .dll para cargar las funciones exportadas de luasocket :)
package.path = package.path .. ";" .. script_path .. "/socket module/?.lua" -- En nuestra carpeta actual + "/socket module" vamos a buscar tambien archivos .lua ( osc.lua, url.lua etc... )

-- Conseguimos los modulos socket y osc
local socket = require('socket.core')
 osc = require('osc')

--Variables del servidor base
port = 3000 -- el puerto donde se aloja el server , la ip se obtiene automaticamente
users = {} --el servidor gestiona los slots de usuarios disponibles 
maxusers = 5 --cuantos usuarios simultaneos podemos gestionar
userips = {0, 1, 2, 3, 4}

userServerPort = 3003 -- el puerto donde esta el server de Godot en los moviles/ otros pcs
-- Funciones que nos ofrece el servidor base : 

--- Obtiene la IP del dispositivo donde se está ejecutando e inicializa el socket del servidor :D
function setUp()
  -- Abrimos e inicializamos los sockets udp
  udp1 = assert(socket.udp())
  udp = assert(socket.udp())
  assert(udp1:setpeername("177.44.4.1",3004)) -- Informacion aleatoria es solo para inicializarlo
  ip,n = udp1:getsockname()--tras inicializarlo nos puede dar la IP de este oredenador :)
  reaper.ShowConsoleMsg("\nTu codigo de host es :")
  reaper.ShowConsoleMsg("\n")
  reaper.ShowConsoleMsg(ip)
  reaper.ShowConsoleMsg("\n")
  --Hemos establecido que el servidor de nuestro programa estara en el puerto 3000:
  assert(udp:setsockname(ip,port))
  udp:settimeout(0.0001) -- Dont forget to set a low timeout! udp:receive block until have a message or timeout. values like (1) will make REAPER laggy.
end

function print(...) 
  local t = {}
  for i, v in ipairs( { ... } ) do
      t[i] = tostring( v )
  end
end

function getUserIP(id)
  return userips[id]
end
function createUserSlots()
users = {}
for i = 0, maxusers - 2 do
  table.insert(users, i)
end
end  


--testing
--assert(udp:setsockname("127.0.0.1",9004)) -- Set IP and PORT
--local msg1 = osc.encode('/t connect', 666, 3.14, 'hello world!')
--udp:sendto(msg1, "192.168.1.56",3003)



--reaper.ShowConsoleMsg(#users)-- # es el lenght opeerator en lua :0

--Funciones para las otras actions

--Vamos a dejar esta funcion escuchando para gestionar la conexion y desocnexion de usuarios  eso es el reaper.defer()
 function Main()
 for address, values in osc.enumReceive(udp) do
     
     --obtenemos los argumentos una vez por mensaje y dependiendo del tipo de mensaje gestionamos.    
     args = {}
     i = 0
     for k ,v in ipairs(values) do
      args[i] = v
      i = i+1
     end 
    reaper.ShowConsoleMsg("\nArray users: \n")
    for i, v in ipairs(users) do
      reaper.ShowConsoleMsg(tostring(v))
    end
      reaper.ShowConsoleMsg("\n")
     --Gestionamos los distintos tipos de mensajes :
     --Conexion de un usuario nuevo : 
      if address == 't/connect' or address == 't/edit' then
        if #users > 0 then 
        if address == 't/connect' then
          if #users>2 then
           i = math.random(1 ,#users -2)
          
          else
           i=1
          end
          reaper.ShowConsoleMsg("random:")
          reaper.ShowConsoleMsg(i)
          u = users[i]
        elseif address == 't/edit' then
          u = 4
        end
        
        reaper.ShowConsoleMsg("\nConectado:")
        reaper.ShowConsoleMsg(u)
        userips[u] = args[0]--cableado para el bajista
      --local msg1 = osc.encode('/t connect', users[u], 3.14, 'hello world!')
      --Voy a cablear el 2 para probar el bajo
        local msg1 = osc.encode('/t connect', u, 3.14, 'hello world!')
        onConnect(u)--Forzado par ael Bass player , deberia ser la U 
        userIP , userPort = udp:getsockname()
      --reaper.ShowConsoleMsg('user ip')
     -- reaper.ShowConsoleMsg(userIP)
      --reaper.ShowConsoleMsg('user port')
        udp:sendto(msg1,args[0],userServerPort)
        table.remove(users, i) --ese slot de usuario ya no esta disponible
      else
        reaper.ShowConsoleMsg("\nSlots de usuario ocupados")
      end
      end
      
      --Desconexion de un usuario 
      --nos envia su token y lo devolvemos a la lista
      if address == 't/disconnect' then
        local disconnectMsg = osc.encode(address, 0, 0, '')
        reaper.ShowConsoleMsg("\nargs[0] es")
        reaper.ShowConsoleMsg(args[0])
        u = args[0]
        reaper.ShowConsoleMsg("\nDesconectado:")
        reaper.ShowConsoleMsg(u)
        table.insert(users,u)
        userips[u] = u
        a = args[0]
        onDisconnect(a)
      end
     -- print('address: ', address)
      --print('This message haves '..#values..' values:')
      for k, v in ipairs(values) do
        --print('    ', v)
      end
    end

    reaper.defer(Main) -- Se usa defer para que la funcion siga ejecutandose y procesando input similar a runloop()
    
end

function onConnect(a)
  reaper.ShowConsoleMsg(a)
  end
function onDisconnect(a)
  end

--- Script: 
--Main()
--return body
