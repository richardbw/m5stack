#!/bin/bash
#
#  auth: rbw
#  date: 20210419
#  desc: 
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BASE_DIR=`cd "${0%/*}/." && pwd`


CA_DATA_DIR=${BASE_DIR}/ca_data
[ -d "$CA_DATA_DIR" ] && rm -r $CA_DATA_DIR && echo "Deleted $CA_DATA_DIR"

CERTS="$BASE_DIR/certs" 
[ -d "$CERTS" ] && rm -r $CERTS && echo "Deleted $CERTS"
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
