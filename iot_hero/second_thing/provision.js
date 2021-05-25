const aws = require('aws-sdk')
const fs = require('fs')
const path = require('path')

// Replace with your AWS region if different 
const AWS_REGION = 'eu-west-2' 
const iotcore = new aws.Iot({region: AWS_REGION})
const axios = require('axios')

const AWS_IOT_POLICY = require('./policy').AWS_IOT_POLICY
const URL_ROOTCA = "https://www.amazontrust.com/repository/AmazonRootCA1.pem"


const provisionning = async (thingName, policy) => {
    
    try{
        // Create a thing
        const THING = await iotcore.createThing({thingName: thingName}).promise()
        console.log(THING)

        // Create certificate an store the files in the folder certs/
        const KEYS = await iotcore.createKeysAndCertificate({setAsActive: true}).promise()
        console.log(`${__dirname}/certs/${thingName}_crt.pem`)
        await fs.writeFileSync(path.join(`${__dirname}/certs/${thingName}_crt.pem`), KEYS.certificatePem)
        await fs.writeFileSync(path.join(`${__dirname}/certs/${thingName}_key.pem`), KEYS.keyPair.PrivateKey)
        
        // Get the Amazon root CA and store it in the folder certs/
        const AMAZON_ROOT_CA = await axios.get(URL_ROOTCA)
        await fs.writeFileSync(path.join(`${__dirname}/certs/rootCA.pem`), AMAZON_ROOT_CA.data)
        console.log(AMAZON_ROOT_CA.data)
        
        //Create a policy but first check if it already exists
        let POLICY = null
        try{
            POLICY =  await iotcore.getPolicy({policyName: `${thingName}_policy`}).promise()
        } catch (e){
            POLICY = await iotcore.createPolicy({policyName: `${thingName}_policy`, policyDocument: JSON.stringify(policy)}).promise() 
        }
  
        // Attach the policy to the principal (the certificate)
        const PRINCIPAL = KEYS.certificateArn
        const ATTACH_POLICY = await iotcore.attachPolicy({policyName: POLICY.policyName, target: PRINCIPAL}).promise()
        
        // Attach the principal (certificate) to the thing
        const ATTACH_THING_PRINCIPAL = await iotcore.attachThingPrincipal({principal: PRINCIPAL, thingName: THING.thingName}).promise()
        
        console.log('PROVISIONING OK')     
        
    } catch(e){
        console.log('ERROR DURING PROVISIONING')
    }
        
    }   
    
    
// call the function provisionning 
provisionning('my_second_thing', AWS_IOT_POLICY)


