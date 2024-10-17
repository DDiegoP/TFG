import dgram from 'dgram';

const client = dgram.createSocket('udp4');

//Ip server
const serverIP = '192.168.1.40'; 
const serverPort = 3000; 

const localPort = 9000

// Mensaje
const message = Buffer.from('/play', 'utf8');
console.log('Mensaje a enviar:', message.toString());

client.bind(localPort, () => {
  console.log(`Vinculado al puerto ${localPort}`);
});
// Envía el mensaje al servidor
client.send(message, 0, message.length, serverPort, serverIP, (err) => {
  if (err) {
    console.error('Error sending message:', err);
  } else {
    console.log('Mensaje enviado al servidor');
  }
  client.close();
});