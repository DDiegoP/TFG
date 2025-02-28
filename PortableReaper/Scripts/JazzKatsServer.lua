--Agregamos los paths de donde a buscar las dependencias
local Info       = debug.getinfo (1, 'S');
local ScriptPath = Info.source:match[[^@?(.*[\/])[^\/]-$]];
package.path     = ScriptPath .. '?.lua;'  .. package.path;--Que realmente es donde estamos pero no busca aqui por defecto

require("ReaServer") --Usamos nuestra clase de utilidad y la modificamos con la funcionaliad especifica de nuestro jeugo
--Esto ejecuta todo el set up y nos imprimer la ip en consola y eso :)

--Nuestro Juego es para 4 jugadores asi qeu especificamos 4 slots de usuario
maxusers = 4
createUserSlots()
setUp()



a = getUserIP(1)
reaper.ShowConsoleMsg(a)

Main()
