#!/usr/bin/python
import paho.mqtt.client as mqtt
import time
from time import gmtime, strftime
from influxdb import InfluxDBClient
chipid = "5ccf7f0b57"
#chipid = "5ccf7fd3ca17"
#chipid = "d3ca17"
#chipid = "19f0f9"
influxdb_host = '10.0.2.15'
influxdb_port = 8086
influxdb_user = 'admin'
influxdb_password = 'admin'
influxdb_dbname = 'mydb'
mqtt_host = "172.18.210.10"

def get_time():
  time_now = strftime("%Y-%m-%dT%H:%M:%SZ", gmtime())
  return time_now

def on_message(client, userdata, msg):
  global influxdb_client
  if msg.topic == "/otb-iot/%s/status" % chipid: 
    rssi = msg.payload.split(":")[1]
    print "rssi = %s" % rssi
    json_body = [{'measurement':'rssi', 'tags':{'chipId':chipid}, 'time':get_time(), 'fields':{'value':rssi}},]
    influxdb_client.write_points(json_body)

influxdb_client = InfluxDBClient(influxdb_host, influxdb_port, influxdb_user, influxdb_password, influxdb_dbname)
client = mqtt.Client(protocol=mqtt.MQTTv31)
client.on_message = on_message
client.connect(mqtt_host, 1883, 60)
time.sleep(1)
client.subscribe("/otb-iot/#")
client.loop_start()
while True:
  client.publish("/otb-iot/%s" % chipid, "get/info/rssi")
  time.sleep(10)
