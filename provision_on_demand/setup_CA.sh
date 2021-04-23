#!/bin/bash
#
#  auth: rbw
#  date: 20210419
#  desc: 
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BASE_DIR=`cd "${0%/*}/." && pwd`

CERTS="$BASE_DIR/certs" && [ ! -d "$CERTS" ] && mkdir $CERTS
SUBJ="/C=UK/ST=London/L=London/O=barnes-webb.com/CN="
ROOT_CN="Richard Barnes-Webb IoT CA"

head(){
    echo 
    echo 
    echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
    echo "$*"
}
ROOT_KEY=$CERTS/rootCA.private.key
head "1) Creating rootCA key: $ROOT_KEY"
openssl genrsa -out $ROOT_KEY    # NB: add `-des3` to genrsa command to have privatekey with password


ROOT_CERT=$CERTS/rootCA.pem.cert
head "2) Creating rootCA cert: $ROOT_CERT"
openssl req -new -x509 -sha256 -days 3650 -nodes \
    -key $ROOT_KEY          \
    -out $ROOT_CERT         \
    -subj "${SUBJ}${ROOT_CN}"

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
