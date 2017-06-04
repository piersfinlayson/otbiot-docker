Usage - without cron

docker run -d -v ~/container-data/script1:/usr/src/app piersfinlayson/otbiot-python python script1.py

or

docker run -d --restart always --name script1 -v ~/container-data/script1:/usr/src/app piersfinlayson/otbiot-python python script1.py

Usage - with cron (note create crontab here: crond/root/crontab!)

docker run -d --restart always --name script1 -v ~/container-data/script1/crond:/usr/src/crond -v ~/container-data/script1/app:/usr/src/app piersfinlayson/otbiot-python crond -c /usr/src/crond -d 2 -f 
