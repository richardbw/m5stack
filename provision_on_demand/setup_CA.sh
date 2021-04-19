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
SUBJ="/C=UK/ST=London/L=London/O=barnes-webb.com/CN="
ROOT_CN="Richard Barnes-Webb IoT CA"

[ ! -f "$OPENSSL_CONF" ] && echo "ERROR: Expecting CA conf file at: $OPENSSL_CONF"  && exit 5

head(){
    echo 
    echo 
    echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
    echo "$*"
}

head "1) Creating $CA_DATA_DIR and empty data files"
mkdir $CA_DATA_DIR 
touch $CA_DATA_DIR/index.txt || (echo "ERROR: Unable to create $CA_DATA_DIR.index.txt"  && exit 6)
echo '01' > $CA_DATA_DIR/serial


head "2) Creating rootCA key"
openssl genrsa                              \
    -out $CA_DATA_DIR/rootCA.private.key    # NB: add `-des3` to genrsa command to have privatekey with password


head "3) Creating rootCA cert"
openssl req -new -x509 -sha256 -days 3650 -nodes -extensions v3_ca   \
    -key $CA_DATA_DIR/rootCA.private.key            \
    -out $CA_DATA_DIR/rootCA.cert                   \
    -subj "${SUBJ}${ROOT_CN}"

head "$(tree $CA_DATA_DIR)"

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
