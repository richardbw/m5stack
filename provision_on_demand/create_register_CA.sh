#!/bin/bash
#
#  auth: rbw
#  date: 20210419
#  desc: 
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BASE_DIR=`cd "${0%/*}/." && pwd`

CERTS="$BASE_DIR/certs" && [ ! -d "$CERTS" ] && mkdir $CERTS

ROOT_KEY=$CERTS/rootCA.private.key
ROOT_CERT=$CERTS/rootCA.pem.cert

VERFIC_KEY=$CERTS/verificationCert.private.key
VERFIC_CSR=$CERTS/verificationCert.csr
VERFIC_CERT=$CERTS/verificationCert.signed.cert

SUBJ="/C=UK/ST=London/L=London/O=barnes-webb.com/CN=Richard Barnes-Webb IoT CA"
CA_CERT_CONFIG="
[req]
distinguished_name=dn
[ dn ]
[ ext ]
basicConstraints=CA:TRUE,pathlen:0
"


[ ! -f "${BASE_DIR}/AWS_IOT_ENVARS" ] && echo "ERROR: Expecting AWS_IOT_ENVARS file"  && exit 18
source AWS_IOT_ENVARS


head(){ #{{{
    echo
    echo
    echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
    echo "$*"
} #}}}

head "1) Create CA Cert..." #{{{
openssl req -new -newkey rsa:2048 -nodes -x509  \
    -extensions ext                             \
    -config     <(echo "$CA_CERT_CONFIG")       \
    -subj       "${SUBJ}"                       \
    -keyout     $ROOT_KEY                       \
    -out        $ROOT_CERT                      \
    
#}}}    
head "2) Getting AWS IoT registration code..." #{{{
AWS_REG_CODE="$(aws iot get-registration-code | jq -r '.registrationCode')"
echo "Code is: ${WHITE}$AWS_REG_CODE${OFF}"

#}}}
head "3) Creating CSR for Root key" #{{{
openssl req                             \
    -new                                \
    -key $ROOT_KEY                      \
    -out $VERFIC_CSR                    \
    -subj "/CN=${AWS_REG_CODE}"         \


#}}}
head "4) Signing verificationCert key" #{{{

#NBNBNBNB: hardcoded CA cert below:
openssl x509  -req -sha256              \
    -days 500  -CAcreateserial          \
    -CA    certs/rootCA.pem.cert        \
    -CAkey $ROOT_KEY                    \
    -in    $VERFIC_CSR                  \
    -out   $VERFIC_CERT                 \



#}}}
head "5) Register verificationCert and registration-config template in AWS" #{{{
echo "JITP_ROLEARN: $JITP_ROLEARN"

REGISTER_CONFIG_TEMPL=$BASE_DIR/provisioning-template.json
cat <<EOT > $REGISTER_CONFIG_TEMPL
{
 "roleArn":"$JITP_ROLEARN",
 "templateBody": "{ \"Parameters\" : { \"AWS::IoT::Certificate::Country\" : { \"Type\" : \"String\" }, \"AWS::IoT::Certificate::Id\" : { \"Type\" : \"String\" } }, \"Resources\" : { \"thing\" : { \"Type\" : \"AWS::IoT::Thing\", \"Properties\" : { \"ThingName\" : {\"Ref\" : \"AWS::IoT::Certificate::Id\"}, \"AttributePayload\" : { \"version\" : \"v1\", \"country\" : {\"Ref\" : \"AWS::IoT::Certificate::Country\"}} } }, \"certificate\" : { \"Type\" : \"AWS::IoT::Certificate\", \"Properties\" : { \"CertificateId\": {\"Ref\" : \"AWS::IoT::Certificate::Id\"}, \"Status\" : \"ACTIVE\" } }, \"policy\" : {\"Type\" : \"AWS::IoT::Policy\", \"Properties\" : { \"PolicyDocument\" : \"{\\\\\"Version\\\\\": \\\\\"2012-10-17\\\\\",\\\\\"Statement\\\\\": [{\\\\\"Effect\\\\\":\\\\\"Allow\\\\\",\\\\\"Action\\\\\": [\\\\\"iot:Connect\\\\\",\\\\\"iot:Publish\\\\\"],\\\\\"Resource\\\\\" : [\\\\\"*\\\\\"]}]}\" } } } }"
}
EOT

REGISTER_DETAILS="$BASE_DIR/AWS_cert_register_details.$(date +%Y-%m-%d_%Hh%M).json"
aws iot register-ca-certificate                         \
    --set-as-active                                     \
    --allow-auto-registration                           \
    --ca-certificate      file://$ROOT_CERT             \
    --verification-cert   file://$VERFIC_CERT           \
    --registration-config file://$REGISTER_CONFIG_TEMPL \
    | jq '. + {"registrationCode":"'$AWS_REG_CODE'"}' | tee $REGISTER_DETAILS

echo "Cleaning up template ($REGISTER_CONFIG_TEMPL)"
rm $REGISTER_CONFIG_TEMPL
#}}}

#CERT_ID=$(cat $REGISTER_DETAILS | jq -r '.certificateId')
#head "6) Activate cert $CERT_ID"
#aws iot describe-ca-certificate --certificate-id $CERT_ID
#aws iot update-ca-certificate --new-status ACTIVE --certificate-id $CERT_ID


            
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
