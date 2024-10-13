import dgram from 'dgram';

const client = dgram.createSocket('udp4');

//Ip server
const serverIP = '192.168.1.42'; 
const serverPort = 3000; 

// Mensaje
const message = Buffer.from('/play');

// Envía el mensaje al servidor
client.send(message, 0, message.length, serverPort, serverIP, (err) => {
  if (err) {
    console.error('Error sending message:', err);
  } else {
    console.log('Mensaje enviado al servidor');
  }
  client.close();
});