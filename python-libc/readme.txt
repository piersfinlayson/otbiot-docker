This docker image differs from otbiot-python in that it also contains glibc compatible libc - useful for running mbus_tools for example.

Usage - without cron

docker run -d -v ~/container-data/script1:/usr/src/app piersfinlayson/otbiot-python python script1.py

or

docker run -d --restart always --name script1 -v ~/container-data/script1:/usr/src/app piersfinlayson/otbiot-python python script1.py

Usage - with cron (note create crontab here: crontabs/root - make sure owned by root:root and permissions 600)

docker run -d --restart always --name script1 -v ~/container-data/script1/crontabs:/var/spool/cron/crotabs -v ~/container-data/script1/app:/usr/src/app piersfinlayson/otbiot-python crond -d 2 -f 
