--Agregamos los paths de donde a buscar las dependencias
local Info       = debug.getinfo (1, 'S');
local ScriptPath = Info.source:match[[^@?(.*[\/])[^\/]-$]];
package.path     = ScriptPath .. '?.lua;'  .. package.path;--Que realmente es donde estamos pero no busca aqui por defecto

require("OscToMidi")
--pista en la que esta el item que queremos escribimos
t=2

translateMessage(68,1,false)
