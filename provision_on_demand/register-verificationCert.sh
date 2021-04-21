#!/bin/bash
#
#  auth: rbw
#  date: 20210419
#  desc: 
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BASE_DIR=`cd "${0%/*}/." && pwd`


export OPENSSL_CONF=${BASE_DIR}/CA.conf
CA_DATA_DIR=${BASE_DIR}/ca_data
CERTS="$BASE_DIR/certs" && [ ! -d "$CERTS" ] && mkdir $CERTS
SUBJ="/C=UK/ST=London/L=London/O=barnes-webb.com/CN="


[ ! -f "$OPENSSL_CONF" ] && echo "ERROR: Expecting CA conf file at: $OPENSSL_CONF"  && exit 5
[ ! -f "${BASE_DIR}/AWS_IOT_ENVARS" ] && echo "ERROR: Expecting AWS_IOT_ENVARS file"  && exit 18

source AWS_IOT_ENVARS

head(){
    echo
    echo
    echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
    echo "$*"
}

head "1) Getting AWS IoT registration code..."
AWS_REG_CODE="$(aws iot get-registration-code | jq -r '.registrationCode')"
echo "Code is: ${WHITE}$AWS_REG_CODE${OFF}"


head "2) Creating Verification Cert key"
openssl genrsa                                      \
    -out $CERTS/verificationCert.private.key        \

head "3) Creating CSR for Verification Cert key"
openssl req                                         \
    -new                                            \
    -extensions v3_req                              \
    -key ${CERTS}/verificationCert.private.key      \
    -out ${CERTS}/verificationCert.csr              \
    -subj "${SUBJ}${AWS_REG_CODE}"                  \


head "4) Signing verificationCert key"
openssl ca -batch  \
    -keyfile ${CA_DATA_DIR}/rootCA.private.key      \
    -in      ${CERTS}/verificationCert.csr          \
    -out     ${CERTS}/verificationCert.signed.cert  \


head "5) Register verificationCert and registration-config template in AWS"
echo "JITP_ROLEARN: $JITP_ROLEARN"
REGISTER_CONFIG_TEMPL=$BASE_DIR/provisioning-template.json
REGISTER_DETAILS="$BASE_DIR/AWS_cert_register_details.$(date +%Y-%m-%d_%Hh%M).json"
cat <<EOT > $REGISTER_CONFIG_TEMPL
{
 "roleArn":"$JITP_ROLEARN",
 "templateBody": "{ \"Parameters\" : { \"AWS::IoT::Certificate::Country\" : { \"Type\" : \"String\" }, \"AWS::IoT::Certificate::Id\" : { \"Type\" : \"String\" } }, \"Resources\" : { \"thing\" : { \"Type\" : \"AWS::IoT::Thing\", \"Properties\" : { \"ThingName\" : {\"Ref\" : \"AWS::IoT::Certificate::Id\"}, \"AttributePayload\" : { \"version\" : \"v1\", \"country\" : {\"Ref\" : \"AWS::IoT::Certificate::Country\"}} } }, \"certificate\" : { \"Type\" : \"AWS::IoT::Certificate\", \"Properties\" : { \"CertificateId\": {\"Ref\" : \"AWS::IoT::Certificate::Id\"}, \"Status\" : \"ACTIVE\" } }, \"policy\" : {\"Type\" : \"AWS::IoT::Policy\", \"Properties\" : { \"PolicyDocument\" : \"{\\\\\"Version\\\\\": \\\\\"2012-10-17\\\\\",\\\\\"Statement\\\\\": [{\\\\\"Effect\\\\\":\\\\\"Allow\\\\\",\\\\\"Action\\\\\": [\\\\\"iot:Connect\\\\\",\\\\\"iot:Publish\\\\\"],\\\\\"Resource\\\\\" : [\\\\\"*\\\\\"]}]}\" } } } }"
}
EOT
aws iot register-ca-certificate                             \
    --set-as-active                                         \
    --allow-auto-registration                               \
    --ca-certificate      file://${CA_DATA_DIR}/rootCA.cert \
    --verification-cert   file://${CERTS}/verificationCert.signed.cert \
    --registration-config file://$REGISTER_CONFIG_TEMPL     \
    | jq '. + {"registrationCode":"'$AWS_REG_CODE'"}' | tee $REGISTER_DETAILS



#CERT_ID=$(cat $REGISTER_DETAILS | jq -r '.certificateId')
#head "6) Activate cert $CERT_ID"
#aws iot describe-ca-certificate --certificate-id $CERT_ID
#aws iot update-ca-certificate --new-status ACTIVE --certificate-id $CERT_ID


            
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
