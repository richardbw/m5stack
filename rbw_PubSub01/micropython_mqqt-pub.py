#
#  auth: rbw
#  date: 20201229
#  desc: 
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

import network,machine,time
from umqtt.simple import MQTTClient
wlan = network.WLAN(network.STA_IF)
wlan.active(True)
if not wlan.isconnected():
    print('connecting to network...')
    wlan.connect(LAN_PASSWORD)
    while not wlan.isconnected(): pass
print('network config:', wlan.ifconfig())


CLIENT_ID   = "m5stack_test"
ENDPOINT    = "a22d4aoxca2zot-ats.iot.us-east-1.amazonaws.com"
MQTT_TOPIC  = 'rbw/test/micropython'
CERT_PATH   = "/rbwM5StickC02_cert_pem_file"
KEY_PATH    = "/rbwM5StickC02_private_key_pem_file"

with open(CERT_PATH, 'r') as f: cert1 = f.read()
with open(KEY_PATH, 'r') as f: key1 = f.read()

print("------------>sleeping for 3s....")
time.sleep_ms(3000)

print("Creating MQTT ......")

mqtt = MQTTClient(
    client_id=CLIENT_ID,
    server=ENDPOINT,
    port=8883,
    keepalive=10000,
    ssl=True,
    ssl_params={ "cert":cert1, "key":key1, "server_side":False })


print("Connecting to MQTT: {}".format(ENDPOINT))
mqtt.connect()
mqtt.publish( topic = MQTT_TOPIC, msg = 'Message from M5StickC', qos = 0 )
print("Published to Topic:{}".format(MQTT_TOPIC))





#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#//EOF
