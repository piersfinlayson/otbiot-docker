FROM python:2-alpine

RUN apk add --update apk-cron && rm -fr /var/cache/apk/*

COPY requirements.txt /

RUN pip install --no-cache-dir -r /requirements.txt

VOLUME ["/var/spool/cron/crontabs/"]

VOLUME ["/usr/src/app/"]

WORKDIR /usr/src/app

