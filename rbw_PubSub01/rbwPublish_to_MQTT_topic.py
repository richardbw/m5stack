#!/usr/bin/env /usr/local/bin/python3
"""
#
#  auth: rbw
#  date: 20201228
#  desc: 
#    parts copied from https://github.com/aws/aws-iot-device-sdk-python-v2/blob/main/samples/pubsub.py
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"""
import sys, time, datetime
from awscrt import io, mqtt 
from awsiot import mqtt_connection_builder
from uuid   import uuid4

import coloredlogs, logging                     #
log = logging.getLogger(__name__)               # https://coloredlogs.readthedocs.io/en/latest/readme.html#usage
coloredlogs.install(level='DEBUG', logger=log)  #


io.init_logging(getattr(io.LogLevel, 'Error'), 'stderr') # OR 'Debug'...


#--------- {{{

CLIENT_ID   = "rbwPublish_to_MQTT_topic.py-"+str(uuid4())
ENDPOINT    = "a22d4aoxca2zot-ats.iot.us-east-1.amazonaws.com"
MQTT_TOPIC  = 'rbw/test/python'
CERT_PATH   = "certs/rbwM5StickC02_cert_pem_file"
KEY_PATH    = "certs/rbwM5StickC02_private_key_pem_file"
CA_PATH     = "certs/AmazonRootCA1.pem"

# }}} ---------

def on_connection_interrupted(connection, error, **kwargs):
    log.error("Connection interrupted. error: {}".format(error))


def on_connection_resumed(connection, return_code, session_present, **kwargs):
    """ Callback when an interrupted connection is re-established. """

    log.info("Connection resumed. return_code: {} session_present: {}".format(return_code, session_present))






def get_connection(): #{{{
    log.debug(""" 
    ENDPOINT    : {} 
    MQTT_TOPIC  : {} 
    CLIENT_ID   : {} 
    """.format(ENDPOINT, MQTT_TOPIC, CLIENT_ID))

    event_loop_group = io.EventLoopGroup(1)
    host_resolver = io.DefaultHostResolver(event_loop_group)
    client_bootstrap = io.ClientBootstrap(event_loop_group, host_resolver)
    return mqtt_connection_builder.mtls_from_path(
            endpoint=ENDPOINT,
            cert_filepath=CERT_PATH,
            pri_key_filepath=KEY_PATH,
            client_bootstrap=client_bootstrap,
            ca_filepath=CA_PATH,
            on_connection_interrupted=on_connection_interrupted,
            on_connection_resumed=on_connection_resumed,
            client_id=CLIENT_ID,
            clean_session=False,
            keep_alive_secs=6
        )
#}}}

def pub_message(conn, mesg):#{{{
    log.info("Publishing message to topic '{}':\n{}".format(MQTT_TOPIC, mesg))

    conn.publish(
        topic=MQTT_TOPIC,
        payload=mesg,
        qos=mqtt.QoS.AT_LEAST_ONCE
    )
#}}}


def main():
    mqtt_connection = get_connection()
    log.debug("mqtt_connection: {}".format(mqtt_connection))

    connect_future = mqtt_connection.connect()
    connect_future.result()    # Future.result() waits until a result is available
    log.info("Connected! (end-point:{})".format(ENDPOINT))

    
    pub_message(mqtt_connection, "XXX_test_mesg_XXX: "+str(datetime.datetime.now()))


    disconnect_future = mqtt_connection.disconnect()
    disconnect_future.result()
    log.info("Disconnected!")



#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if __name__ == "__main__": main()
log.info("Done.")
#//EOF
