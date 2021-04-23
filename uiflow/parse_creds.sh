#!/bin/bash
#
#  auth: rbw
#  date: 20210423
#  desc: 
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BASE_DIR=`cd "${0%/*}/." && pwd`

CREDS=${1:-$BASE_DIR/certs/creds.txt}

[ ! -f "$CREDS" ] && echo "ERROR: creds file not found ($CREDS) - specify on cmdline" && exit 12

PUBKEY="$BASE_DIR/certs/ori_tf_1.key"
CRTKEY="$BASE_DIR/certs/ori_tf_1.pem"

sed -n '3,11 p'  ${CREDS} > $PUBKEY
sed -n '45,64 p' ${CREDS} > $CRTKEY

cat <<EOT
Wrote:
PUBKEY: $PUBKEY
CRTKEY: $CRTKEY

EOT


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
