/*var http = require('http');
console.log("Aaaaaa");
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.write('Hello World!');
  console.log("accesesd");
  res.end();
  
}).listen(8080,scream());
*/ //esto no escucha udp al parecer ? 


import dgram from 'dgram';

// Create a UDP server
const server = dgram.createSocket('udp4');

// Event when receiving a message
//Si recibo aqui el mesjae se pierde y la cosa de godot no se mueve 
// lo puedo devoler ? 
server.on('message', (msg, rinfo) => {
  console.log(`Message received from ${rinfo.address}:${rinfo.port} - Content: ${msg}`);
  scream();
  console.log(msg);
  // Respond to the client
  //En godot el osc Client es este puerto aqui pillamos el mensaje y 
  //lo mandammos al puerto 3001 que es el server en godot para 
  //que el cubo se mueva 
  server.send( msg ,0, msg.length, 3001, rinfo.address, (err) => {
    if (err) {
      console.error('Error sending message:', err);
    } else {
      console.log('Response sent to the client');
    }
   
  });
});

// Event when the server is ready and listening
server.on('listening', () => {
  const address = server.address();
  console.log(`UDP server started at ${address.address}:${address.port}`);
});

// Handle errors
server.on('error', (err) => {
  console.error('Error in UDP server:', err);
  server.close();
});

const port = 3000;
server.bind(port);
function scream()
{
  console.log("AAAAAAAAAAAAAA");
}