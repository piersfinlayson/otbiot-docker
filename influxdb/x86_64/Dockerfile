FROM golang:1.6

LABEL maintainer="Piers Finlayson <piers@piersandkatie.com>"

LABEL description="otbiot influxdb image - x86_64"

RUN apt-get update && apt-get install -y git && apt-get clean && rm -fr /etc/apt/lists/*

ENV INFLUXDB_VERSION 1.2.2

RUN mkdir -p $GOPATH/src/github.com/influxdata \
  && cd $GOPATH/src/github.com/influxdata \
  && git clone https://github.com/influxdata/influxdb \
  && cd influxdb \
  && git checkout tags/v${INFLUXDB_VERSION} \
  && go get -u -f ./... \
  && go build ./... \
  && mv $GOPATH/bin/* /usr/bin/ \
  && rm -fr $GOPATH/*

COPY ../config.toml /etc/influxdb/config.toml

COPY ../docker-entrypoint.sh /

ENV PRE_CREATE_DB otbiot

ENV SSL_SUPPORT **False**

ENV SSL_CERT **None**

EXPOSE 8083 8086

VOLUME ["/var/lib/influxdb"]

ENTRYPOINT ["/docker-entrypoint.sh"]

