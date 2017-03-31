FROM otbiot/alpine:latest

LABEL maintainer="Piers Finlayson <piers@piersandkatie.com>"

LABEL description="otb-iot missing link - Scripts taking data from devices via MQTT and putting into InfluxDB"

RUN apk add --update python py-pip bash \
	&& pip install paho-mqtt \
	&& pip install influxdb \
	&& rm -rf /var/cache/apk/*

RUN mkdir -p /scripts/

COPY docker-entrypoint.sh /
COPY rssi.py /scripts/
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/bin/bash"]
