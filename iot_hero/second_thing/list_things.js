const aws = require('aws-sdk')
const AWS_REGION = 'eu-west-2' // Replace with your AWS region if different 
const iotcore = new aws.Iot({region: AWS_REGION})

const list_things = async () => {
        
            const list = await iotcore.listThings().promise()
                console.log(list)
}

list_things()
