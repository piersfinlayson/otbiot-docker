FROM otbiot/missing-link-from:latest

LABEL maintaier="Piers Finlayson <piers@piersandkatie.com>"

LABEL description="Eclipse Mosquitto Clients"

RUN apk --no-cache add mosquitto-clients

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
