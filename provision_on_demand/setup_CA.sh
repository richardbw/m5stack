#!/bin/bash
#
#  auth: rbw
#  date: 20210419
#  desc: 
# https://stackoverflow.com/questions/36920558/is-there-anyway-to-specify-basicconstraints-for-openssl-cert-via-command-line
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BASE_DIR=`cd "${0%/*}/." && pwd`

CERTS="$BASE_DIR/certs" && [ ! -d "$CERTS" ] && mkdir $CERTS
ROOT_KEY=$CERTS/rootCA.private.key
ROOT_CERT=$CERTS/rootCA.pem.cert
ROOT_CN="Richard Barnes-Webb IoT CA"
SUBJ="/C=UK/ST=London/L=London/O=barnes-webb.com/CN="


CONFIG="
[req]
distinguished_name=dn
[ dn ]
[ ext ]
basicConstraints=CA:TRUE,pathlen:0
"

openssl req -new -newkey rsa:2048   \
    -config <(echo "$CONFIG")       \
    -nodes -x509                    \
    -extensions ext                 \
    -subj       "${SUBJ}${ROOT_CN}" \
    -keyout     $ROOT_KEY           \
    -out        $ROOT_CERT          \

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
