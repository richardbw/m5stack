#!/bin/bash
#
#  auth: rbw
#  date: 20201229
#  desc: 
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BASE_DIR=`cd "${0%/*}/." && pwd`
MAIN="$BASE_DIR/micropython_mqqt-pub.py"
PORT="$(ls /dev/cu.* | grep usb)"
CERTS_DIR="$BASE_DIR/certs"
CERTS="rbwM5StickC02_cert_pem_file rbwM5StickC02_private_key_pem_file"

[ -z "$PORT" ] && echo "ERROR: no USB device detected." && exit 16

for c in $CERTS ; do
    echo "Putting: $c..."
    ampy -p $PORT put "$CERTS_DIR/$c"
done


TMPFILE=$(mktemp -t main.py)  
mv $TMPFILE ${TMPFILE%.*}
TMPFILE=${TMPFILE%.*}
echo "Copying $MAIN to /main.py (via $TMPFILE)"
cp $MAIN $TMPFILE

LAN_PASSWORD=$(< $BASE_DIR/LAN_PASSWORD)
sed -i.bu "s/LAN_PASSWORD/$LAN_PASSWORD/" $TMPFILE

ampy -p $PORT put "$TMPFILE"

echo -------------------------------
echo "Dir list:"
echo "---------"
ampy -p $PORT ls
echo -------------------------------

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
