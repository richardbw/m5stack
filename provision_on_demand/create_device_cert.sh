#!/bin/bash
#
#  auth: rbw
#  date: 20210502
#  desc: 
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BASE_DIR=`cd "${0%/*}/." && pwd`
CERTS="$BASE_DIR/certs" && [ ! -d "$CERTS" ] && mkdir $CERTS
ROOT_KEY=$CERTS/rootCA.private.key
ROOT_CERT=$CERTS/rootCA.pem.cert

DEVICE_NAME="$1"

[ -z "$DEVICE_NAME" ]                               && \
    echo "Enter device name to create and register" && \
    echo -n "> "                                    && \
    read DEVICE_NAME                                

SUBJ="/C=UK/ST=London/L=London/O=barnes-webb.com/CN=$DEVICE_NAME"

echo "Script with create ${WHITE}${DEVICE_NAME}${OFF}..."

echo "Creating device key & cert.."
openssl req -new -newkey rsa:2048 -nodes    \
    -subj   "${SUBJ}"                       \
    -keyout $CERTS/d_${DEVICE_NAME}.key     \
    -out    $CERTS/d_${DEVICE_NAME}.csr     \


#NNNB hardcoded CA path
openssl x509 -req  -sha256                  \
    -days 365 -CAcreateserial               \
    -CA    certs/rootCA.pem.cert            \
    -CAkey $ROOT_KEY                        \
    -in    $CERTS/d_${DEVICE_NAME}.csr      \
    -out   $CERTS/d_${DEVICE_NAME}.crt      \


cat <<EOT

DETAILS
-------
Device cert:     ${GREEN}$CERTS/d_${DEVICE_NAME}.cert${OFF}
Device key:      ${GREEN}$CERTS/d_${DEVICE_NAME}.key${OFF}
AWS end-point:   ${GREEN}$(aws iot describe-endpoint | jq -r '.endpointAddress')${OFF}

EOT

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
