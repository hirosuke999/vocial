import { Socket } from 'phoenix'

const socket = new Socket('/socket')
socket.connect()

if (document.getElementById('enable-polls-channel')) {
  const channel = socket.channel('polls:lobby', {})
  channel
    .join()
    .receive('ok', res => console.log('Joined channel:', res))
    .receive('error', res => console.log('Failed to join channel:', res))

  document.getElementById('polls-ping').addEventListener('click', () => {
    channel
      .push('ping')
      .receive('ok', res => console.log('Received PING response:', res.message))
      .receive('error', res => console.log('Error sending PING:', res))
  })

  channel.on('pong', payload => {
    console.log("The server has been PONG'd and all is well:", payload)
  })
}

export default socket
