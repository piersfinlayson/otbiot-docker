FROM piersfinlayson/esp8266-build-from:2.0

LABEL maintainer="Piers Finlayson <piers@piersandkatie.com>"

LABEL description="Piers's General Build Container"

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
	texinfo \
	unzip \
	unrar-free \
	vim \
	wget 

RUN curl https://sh.rustup.rs -sSf | sh

RUN useradd -ms /bin/bash build && usermod -a -G dialout build && usermod -a -G i2c build && usermod -a -G spi build

ADD VERSION /

USER build
WORKDIR /home/build/

RUN mkdir /home/build/builds
RUN chown -R build:build /home/build/builds
VOLUME ["/home/build/builds"]

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/bin/bash"]
