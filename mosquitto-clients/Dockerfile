FROM otbiot/alpine:latest

LABEL maintainer="Piers Finlayson <piers@piersandkatie.com>"

LABEL description="Eclipse Mosquitto Clients"

RUN apk --no-cache add mosquitto-clients

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
