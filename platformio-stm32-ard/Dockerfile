FROM ubuntu:16.04

LABEL maintainer="Piers Finlayson <piers@piersandkatie.com>"
LABEL description="Platformio STM32 Development Container"

# Install Ubuntu packages
RUN apt-get update && \
    apt-get install -y python2.7 python-pip vim stm32flash libusb-1.0-0

# Install platformio
RUN pip install -U platformio
COPY 99-platformio-udev.rules /lib/udev/rules.d/99-platformio-udev.rules

# Add user "build" and set permissions to access suitable devices
RUN useradd -ms /bin/bash build && usermod -a -G dialout build && usermod -a -G plugdev build

# Put useful platformio template file in home directory
USER build
WORKDIR /home/build/
COPY platformio.ini.template /home/build/platformio.ini.template

# Predownload STM32 framework
RUN mkdir /home/build/temp/ && \
    cd /home/build/temp/ && \
    pio init && \
    rm /home/build/temp/platformio.ini && \
    cp /home/build/platformio.ini.template /home/build/temp/platformio.ini && \
    echo "void setup(){} void loop(){}" > /home/build/temp/src/main.ino && \
    pio run && \
    cd /home/build/ && \
    rm -fr /home/build/temp/

# Create builds directory as a volume
RUN mkdir /home/build/builds
RUN chown -R build:build /home/build/builds
VOLUME ["/home/build/builds"]

# Final setup
COPY docker-entrypoint.sh /
ENV PATH /home/build/:$PATH
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
