Usage

docker run -d -v ~/container-data/script1:/usr/src/app piersfinlayson/otbiot-python python script1.py

or

docker run -d --restart always --name script1 -v ~/container-data/script1:/usr/src/app piersfinlayson/otbiot-python python script1.py
