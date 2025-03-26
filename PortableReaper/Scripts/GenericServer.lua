--Agregamos los paths de donde a buscar las dependencias
local Info       = debug.getinfo (1, 'S');
local ScriptPath = Info.source:match[[^@?(.*[\/])[^\/]-$]];
package.path     = ScriptPath .. '?.lua;'  .. package.path;--Que realmente es donde estamos pero no busca aqui por defecto

require("ReaServer") --Usamos nuestra clase de utilidad y la modificamos con la funcionaliad especifica de nuestro jeugo
--Esto ejecuta todo el set up y nos imprime la ip en consola y eso :)
function onConnect(a) -- override de que pasa en mi juego en especifico cuando se concecta alguien
 -- reaper.ShowConsoleMsg("b")
 if a == 3 then
  reaper.ShowConsoleMsg("other connected")
  
 end
  
  end
  
function onDisconnect(a) -- override de que pasa en mi juego en especifico cuando se desconcecta alguien
  reaper.ShowConsoleMsg("other disconnected")
  end  
--Nuestro Juego es para 4 jugadores asi qeu especificamos 4 slots de usuario
maxusers = 4
createUserSlots()
setUp()



a = getUserIP(1)
reaper.ShowConsoleMsg(a)

Main()
