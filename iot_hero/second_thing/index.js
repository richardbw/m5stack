// Declare the AWS IoT Device SDK for JavaScript and Node library
const awsiot = require('aws-iot-device-sdk')

// Declare the thingName and the topic
const thingName = 'my_second_thing'
const topic = `heroiotworkshop/${thingName}`

//Declare the aws IoT endpoint
const endpoint = 'a3k7g2citz8r11-ats.iot.eu-west-2.amazonaws.com' // xxxxxxxxxxxxx-ats.iot.AWS_REGION.amazonaws.com

const device = awsiot.device({
   keyPath: `./certs/${thingName}_key.pem`,
  certPath: `./certs/${thingName}_crt.pem`, 
    caPath: `./certs/rootCA.pem`,
  clientId: thingName,
      host: endpoint 
})

device.on('connect', () => {
    console.log(`${thingName} is connected to ${endpoint}`)
    
    // subscribe to the the topic 
    device.subscribe(topic)
    
    device.publish(topic, JSON.stringify({ message: "pi> I am an AWS IoT Hero :-)" }))
    
    // This function send the message each 5 seconds
    setInterval(() => {
         device.publish(topic, JSON.stringify({ message: "pi>I am an AWS IoT Hero :-)" }))
    }, 5000)
})

device.on('message', (topic, message) => {
    console.log(`Message received: ${message.toString()} in the topic ${topic}`)
})
