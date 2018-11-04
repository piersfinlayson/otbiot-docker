FROM piersfinlayson/esp8266-build-from:2.0

LABEL maintainer="Piers Finlayson <piers@piersandkatie.com>"

LABEL description="Piers's General Build Container"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	autoconf \
	automake \
	bash \
	bison \
	bzip2 \
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

RUN useradd -ms /bin/bash build && usermod -a -G dialout build && usermod -a -G i2c build 

USER build
WORKDIR /home/build/

RUN mkdir /home/build/builds
RUN chown -R build:build /home/build/builds

RUN cd /home/build && /usr/bin/wget https://sh.rustup.rs -O rust.sh && /bin/bash rust.sh -y && rm /rust.sh
ENV PATH="/home/build/.cargo/bin:${PATH}"

ADD VERSION /
VOLUME ["/home/build/builds"]
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/bin/bash"]
