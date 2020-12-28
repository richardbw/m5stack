#!/usr/bin/env /usr/local/bin/python3
#
#  auth: rbw
#  date: 20201228
#  desc: 
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
from awscrt import io, mqtt, auth, http
from awsiot import mqtt_connection_builder
import sys, time
from uuid import uuid4

import coloredlogs, logging                     #
log = logging.getLogger(__name__)               # https://coloredlogs.readthedocs.io/en/latest/readme.html#usage
coloredlogs.install(level='DEBUG', logger=log)  #

io.init_logging(getattr(io.LogLevel, 'Debug'), 'stderr')



#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print("Done.")
#//EOF
