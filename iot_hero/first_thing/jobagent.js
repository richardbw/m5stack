// Declare the AWS IoT Device SDK for JavaScript and Node library
const awsiot = require('aws-iot-device-sdk')
const aws = require('aws-sdk')

const AWS_REGION = 'eu-west-2' // Replace with your AWS region if different 
const iotcore = new aws.Iot({region: AWS_REGION})

// Declare the thingName and the topic
const thingName = 'my_first_thing'
const job_notification_topic = `$aws/things/${thingName}/jobs/notify`

//Declare the aws IoT endpoint
const endpoint = 'a3k7g2citz8r11-ats.iot.eu-west-2.amazonaws.com' // xxxxxxxxxxxxx-ats.iot.AWS_REGION.amazonaws.com

const job = awsiot.jobs({
   keyPath: `./certs/${thingName}_key.pem`,
  certPath: `./certs/${thingName}_crt.pem`, 
    caPath: `./certs/rootCA.pem`,
  clientId: thingName,
      host: endpoint 
})

job.on('connect', () => {
    console.log(`job agent for ${thingName} is connected to ${endpoint}`)
})

//startJobNotifications to cause any existing queued job executions for the given thing to be published to the appropriate subscribeToJobs handler
job.startJobNotifications(thingName, (err) => {
    if(err)
        throw new Error('Oops something went wrong')
    console.log(`job notifications initiated for thing: ${thingName}`)
})

// the subscribeToJobs method which takes a callback that will be invoked when a job execution is available or an error occurs.
job.subscribeToJobs(thingName, async (err, jb)=> {
    if(err)
        throw new Error('Oops something went wrong...')
    console.log(`job with id: ${jb.id} received.`)
    console.log(`operation: ${jb.document.operation} ${thingName} to version ${jb.document.version} start ...`)
    console.log(`...`)
    let upgrade = await upgrade_firmware(jb.document.version.toString(), thingName)
    if(upgrade){
        console.log(`job with id: ${jb.id} succeeded`)
        jb.succeeded({ 'status': 'success', 'progress': '100%'}, (err) => {
            if(err)
                throw new Error('Oops, something went wrong...')
        })
    }
})


const upgrade_firmware = async (version, thingName) => {
    try{
        let update_thing = await iotcore.updateThing({
                                            thingName: thingName,
                                             attributePayload: {
                                                    attributes: {
                                                         firmware_version: version
                                                    },
                                                    merge: true
                                             }}).promise()  
     return true
    } catch(e){
        console.log(e)
     return false
    }
        
}


