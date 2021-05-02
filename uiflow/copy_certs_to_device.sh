#!/bin/bash
#
#  auth: rbw
#  date: 20210423
#  desc: 
# @see https://github.com/scientifichackers/ampy
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BASE_DIR=`cd "${0%/*}/." && pwd`

PORT="$(ls /dev/cu.* | grep usb)"
CERTS="$*"
DEV_CERT_DIR="/flash/res"

[ -z "$PORT" ] && echo "ERROR: no USB device detected." && exit 16
[ -z "$1"    ] && echo "ERROR: No certprefix in cmdline." && exit 7

echo "export AMPY_PORT=$PORT"

echo -------------------------------
for c in ${CERTS} ; do
    [ ! -f "$c" ] && "WARN: not found $c" && continue
    DEST_PATH="$DEV_CERT_DIR/$(basename "$c")"
    echo "Putting: [$c] to [$DEST_PATH] ... "
    ampy -p $PORT put "$c" "${DEST_PATH}"
done
echo -------------------------------

echo -------------------------------
echo "Dir list:"
echo "---------"
ampy -p $PORT ls $DEV_CERT_DIR
echo -------------------------------

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
