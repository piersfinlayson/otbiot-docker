FROM piersfinlayson/esp8266-build-from:2.0

LABEL maintainer="Piers Finlayson <piers@piersandkatie.com>"

LABEL description="Piers's General Build Container"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	autoconf \
	automake \
	bash \
	bison \
	bzip2 \
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

RUN cd /home/build && /usr/bin/wget https://sh.rustup.rs -O rust.sh && /bin/bash rust.sh -y && rm /home/build/rust.sh
RUN /home/build/.cargo/bin/rustup component add rustfmt-preview
RUN /home/build/.cargo/bin/rustup component add clippy-preview; exit 0

ENV PATH="/home/build/.cargo/bin:${PATH}"

COPY .vimrc /home/build/
RUN mkdir /home/build/builds
RUN chown -R build:build /home/build/builds

USER root
RUN apt install -y pkg-config libssl-dev
USER build

ADD VERSION /
VOLUME ["/home/build/builds"]
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/bin/bash"]
