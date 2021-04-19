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


head "5) Register verificationCert in AWS"
aws iot register-ca-certificate                             \
    --ca-certificate    file://${CA_DATA_DIR}/rootCA.cert   \
    --verification-cert file://${CERTS}/verificationCert.signed.cert \
    | jq | tee AWS_cert_register_details.$(date +%Y-%m-%d_%Hh%M).json

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
