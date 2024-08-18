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
server.on('message', (msg, rinfo) => {
  console.log(`Message received from ${rinfo.address}:${rinfo.port} - Content: ${msg}`);
  scream();
  // Respond to the client
  server.send('Message received by the server', rinfo.port, rinfo.address, (err) => {
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

const port = 8080;
server.bind(port);
function scream()
{
  console.log("AAAAAAAAAAAAAA");
}