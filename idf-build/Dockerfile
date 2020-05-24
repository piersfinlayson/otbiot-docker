FROM piersfinlayson/esp8266-build-from:2.0

LABEL maintainer="Piers Finlayson <piers@piersandkatie.com>"

LABEL description="Piers's Espressif ESP8266 IDF Build Container"

#
# This container installs Espressif's ESP8266 IDF SDK and xtensa toolset.
#

# Install all necessary packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
		apt-transport-https \
		autoconf \
		automake \
		bash \
		bison \
		bsdtar \
		build-essential \
		bzip2 \
		ca-certificates \
		cmake \
		curl \
		flex \
		g++ \
		gawk \
		gcc \
		git \
		gperf \
		help2man \
		hexedit \
		i2c-tools \
		libexpat-dev \
		libtool \
		libtool-bin \
		make \
		ncurses-dev \
		nano \
		patch \
		pkgconf \
		python \
		python-dev \
    python-pip \
		python-serial \
		python-sphinx \
		sed \
		software-properties-common \
		sudo \
		texinfo \
		unzip \
		unrar-free \
		vim \
		wget && \
    arch=$(dpkg --print-architecture) && \
		echo "Architecture: $(arch)" && \
		if [ $(arch) = "armhf" ] || [ $(arch) = "armv7l" ] || [ $(arch) = "armv6l" ] ; \
		then \
		  echo "ARM - not installing gcc-arm-linux-gnueabihf" ; \
		else \
		  echo "Not ARM - installing gcc-arm-linux-gnueabihf" && \
		  DEBIAN_FRONTEND=noninteractive apt-get install -y gcc-arm-linux-gnueabihf ; \ 
		fi && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

# Add build user
ADD sudoers /etc/sudoers.d/nopasswd
RUN useradd -ms /bin/bash build && \
    usermod -a -G dialout build && \
		usermod -a -G i2c build && \
    usermod -a -G sudo build && \
    mkdir /home/build/builds && \
    chown -R build:build /home/build/builds
USER build
COPY .vimrc /home/build/
RUN cd /home/build

RUN echo "Get xtensa toolset" && \
    cd /home/build && \
    wget https://dl.espressif.com/dl/xtensa-lx106-elf-linux64-1.22.0-100-ge567ec7-5.2.0.tar.gz && \
    tar zxf xtensa-lx106-elf-linux64-1.22.0-100-ge567ec7-5.2.0.tar.gz && \
    rm -f xtensa-lx106-elf-linux64-1.22.0-100-ge567ec7-5.2.0.tar.gz

ARG IDF_VERSION
RUN export IDF_VERSION=$IDF_VERSION && \
    echo "Get IDF" && \
    cd /home/build && \
    git clone https://github.com/espressif/ESP8266_RTOS_SDK.git && \
    cd ESP8266_RTOS_SDK && \
    git checkout remotes/origin/release/$IDF_VERSION

RUN echo "Install IDF Python pre-requisities" && \
    /usr/bin/python -m pip install --user -r /home/build/ESP8266_RTOS_SDK/requirements.txt

RUN echo "Set up IDF_PATH and PATH"
ENV IDF_PATH=/home/build/ESP8266_RTOS_SDK
ENV PATH=$PATH:/home/build/xtensa-lx106-elf/bin:/home/build/ESP8266_RTOS_SDK/tools

RUN echo "Get and build sample project to get various IDF dependencies" && \
    cd /home/build && \
    git clone https://github.com/espressif/esp-idf-template && \
		cd esp-idf-template && \
		idf.py build && \
		cd .. && \
		rm -fr esp-idf-template

# Finish up
USER root
RUN echo "IDF Version: $IDF_VERSION" > /VERSION

USER build
#VOLUME ["/home/build/builds"]
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
