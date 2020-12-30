#!/bin/bash
#
#  auth: rbw
#  date: 20201230
#  desc: 
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BASE_DIR=`cd "${0%/*}/." && pwd`
PORT="$(ls /dev/cu.* | grep usb)"
[ -z "$PORT" ] && echo "ERROR: no USB device detected." && exit 16

picocom -b 115200 $PORT

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
