FROM piersfinlayson/esp8266-build-from:2.1

LABEL maintainer="Piers Finlayson <piers@piersandkatie.com>"

LABEL description="otbiot ESP8266 NonOS SDK Build Container"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	autoconf \
	automake \
	bash \
	bison \
	bzip2 \
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
	python \
	python-dev \
	python-serial \
	python-sphinx \
	sed \
	sudo \
	texinfo \
	unzip \
	unrar-free \
	vim \
	wget && \
        if [ $(arch) = "armhf" ] || [ $(arch) = "armv7l" ] || [ $(arch) = "armv6l" ] ; \
        then \
                echo "ARM - installing wiringPi" && \
                DEBIAN_FRONTEND=noninteractive apt install -y wiringpi ; \
        fi 

ADD sudoers /etc/sudoers.d/nopasswd
RUN useradd -ms /bin/bash esp && \
    usermod -a -G dialout esp && \
    usermod -a -G i2c esp && \
    usermod -a -G sudo esp

ADD VERSION /

USER esp
WORKDIR /home/esp/

# Orignal is pfalcon's but his doesn't support 2.0.0 yet
# RUN cd /home/esp && git clone --recursive https://github.com/pfalcon/esp-open-sdk.git
RUN cd /home/esp && git clone --recursive https://github.com/piersfinlayson/esp-open-sdk.git

RUN cd /home/esp/esp-open-sdk && make && rm -fr /home/esp/esp-open-sdk/crosstool-NG/

RUN mkdir /home/esp/builds
RUN chown -R esp:esp /home/esp/builds
VOLUME ["/home/esp/builds"]

ENV PATH /home/esp/esp-open-sdk/xtensa-lx106-elf/bin:/home/esp/esp-open-sdk/esptool/:$PATH
ENV XTENSA_TOOLS_ROOT /home/esp/esp-open-sdk/xtensa-lx106-elf/bin
ENV SDK_BASE /home/esp/esp-open-sdk

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/bin/bash"]
