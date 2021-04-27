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

PRIKEY="$BASE_DIR/certs/ori_tf_1.key"
CRTKEY="$BASE_DIR/certs/ori_tf_1.pem"

sed -ne '15,41 p' ${CREDS} | sed -e 's/^ *//' > $PRIKEY
sed -ne '45,64 p' ${CREDS} | sed -e 's/^ *//' > $CRTKEY

cat <<EOT
Wrote:
PRIKEY: $PRIKEY
CRTKEY: $CRTKEY

EOT


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
