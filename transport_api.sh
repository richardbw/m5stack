#!/bin/bash
#
#  auth: rbw
#  date: 20231102
#  desc: 
#   https://github.com/transportapi/usage-examples/blob/master/src/examples/train-station-timetable/main.js
#   https://developer.transportapi.com/docs#get-/v3/uk/train/station_timetables/-id-.json
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BASE_DIR=`cd "${0%/*}/." && pwd`


appId='faeafed3'
appKey='624b821315b1982a9141d11ef6479a65'
trainStation='tiploc:MOTSPRP'
url="https://transportapi.com/v3/uk/train/station_timetables/${trainStation}.json?app_id=${appId}&app_key=${appKey}&train_status=passenger"
#url="https://transportapi.com/v3/uk/places.json?app_id=${appId}&app_key=${appKey}&query=park"

curl -v "$url" | jq | tee transport_api.json



#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Done."
#//EOF
