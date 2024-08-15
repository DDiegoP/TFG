CONFIGURAR GODOT PARA BUILDEAR EN ANDROID !

Ingredientes :
Godot 4.2.2
Android Studio 
un sdk 
un jdk 
una llave para la aplicacion 

Preparacion : 
instalar android studio 
crear un proyecto en java 
la plantilla empty views por ejemplo todavia tiene
soporte para java y no solo kotlin.
He usado android 30 para la prueba. 
En l barra de herramientas superior vamos  Build>Generate Signed Bundle / APK
Cualquiera de las 2 opciones qeu ofrece este menu nos sirve solo vamos a hacer esto para tener la key
rellena los datos y APUNTA LA CONTRASEÑA sin la contraseña correcta Godot no nos dejara buildear.
Da igual si te da error al hacer build de la aplicacion solo necesitas el archivo de la clave *.jks


abrir godot , EJECUTAR COMO ADMINISTRADOR !
El renderer tiene qeu ser el que pone mobile.
En la toolbar superior vamos a Project>Install Android Build Template.
Se instala eso y luego vamos a la toolbar superio Editor>Editor Settings 
Abajo del todo en la seccion export entramso en android 
Hay que configurar 2 rutas qeu deberias ser algo parecido a esto 
Android SDK Path = %LOCALAPPDATA%/Android/Sdk es decir C:/Users/user1/AppData/Local/Android/Sdk  por ejemplo 
Java SDK Path = %PROGRAMFILES%/Android/Android Studio/jbr  es decir C:/ProgramFiles/Android/Android Studio/jbr  por ejemplo 

Si no encuentras los sdk en la configuracion de Android Studio están las rutas las puedes consultar.

Ahora podemos en Godot ir a  Project>Export y generar nuestro apk :)



