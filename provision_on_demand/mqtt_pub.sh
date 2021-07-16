#!/bin/bash
#
#  auth: rbw
#  date: 20210503
#  desc: 
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BASE_DIR=`cd "${0%/*}/." && pwd`

MQTT_HOST='a22d4aoxca2zot-ats.iot.us-east-1.amazonaws.com'
MQTT_TOPIC="rbw/test"


CERTS="$BASE_DIR/certs"
DATE="$(date '+%Y-%m-%d %H:%M:%S')"
PAYLOAD="{\"timestamp\": \"${DATE}\"}"

echo "Host         : $MQTT_HOST "| sed "s/\(.*\.iot\)\.\(.*\)\.\(amazonaws.com\)/\1.${BROWN}\2${OFF}.\3/"
echo "Publishing to: ${WHITE}$MQTT_TOPIC${OFF} "
echo "           at: ${WHITE}${DATE}${OFF}" 
echo "----------------------"
mosquitto_pub -q 1 -d                               \
    --tls-version tlsv1.2 -I "$(basename $0)"       \
    --cafile    "$CERTS/rootCA.pem.cert"          \
    --cert      "$CERTS/d_delme1.cert_and_CA-crt.crt"               \
    --key       "$CERTS/d_delme1.key"               \
    -h          "$MQTT_HOST" -p 8883                \
    -t          $MQTT_TOPIC                         \
    -m          "$PAYLOAD"                          \

if [ "$?" == "0" ] ; then
    echo "${GREEN}SUCCESS${OFF}"
else    
    echo "${RED}ERROR${OFF}: $?"
fi
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#//EOF
