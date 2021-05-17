#!/bin/bash
#
#  auth: rbw
#  date: 20210503
#  desc: 
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BASE_DIR=`cd "${0%/*}/." && pwd`

MQTT_HOST='a9dtsgvtlpf54-ats.iot.eu-west-1.amazonaws.com'
MQTT_TOPIC="rbw/test"
CERT_REFIX="$1"


CERTS="$BASE_DIR/certs"
DATE="$(date '+%Y-%m-%d %H:%M:%S')"
PAYLOAD="{\"timestamp\": \"${DATE}\"}"

echo "Cert prefix: $CERT_REFIX"
echo "Publishing to $MQTT_HOST:${WHITE}$MQTT_TOPIC${OFF} at: ${WHITE}${DATE}${OFF}..." 
mosquitto_pub -q 1 -d                               \
    --tls-version tlsv1.2 -I "$(basename $0)"       \
    --cafile    "$CERTS/AmazonRootCA1.pem"          \
    --cert      "$CERTS/$CERT_REFIX.crt"               \
    --key       "$CERTS/$CERT_REFIX.key"               \
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
