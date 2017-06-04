Usage

docker run -v ~/container-data/script1:/usr/src/app piersfinlayson/otbiot-python python script1.py

or

docker run --restart always --name script -v ~/container-data/script1:/usr/src/app piersfinlayson/otbiot-python python script1.py
