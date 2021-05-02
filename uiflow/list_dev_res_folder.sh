#!/bin/bash
#
#  auth: rbw
#  date: 20210426
#  desc: 
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BASE_DIR=`cd "${0%/*}/." && pwd`
PORT="$(ls /dev/cu.* | grep usb)"
DEV_CERT_DIR="/flash/res"
[ -z "$PORT" ] && echo "ERROR: no USB device detected." && exit 16
echo "Listing files in $PORT:$DEV_CERT_DIR..."
ampy -p $PORT ls $DEV_CERT_DIR
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#//EOF
