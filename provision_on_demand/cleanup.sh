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

REGISTER_CONFIG_TEMPL=$BASE_DIR/provisioning-template.json
[ -f "$REGISTER_CONFIG_TEMPL" ] && rm $REGISTER_CONFIG_TEMPL && echo "Deleted $REGISTER_CONFIG_TEMPL"


echo "
NB: Manually delete certs at https://console.aws.amazon.com/iot/home?#/cacertificatehub
"
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
