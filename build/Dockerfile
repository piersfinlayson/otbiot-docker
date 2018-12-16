FROM piersfinlayson/esp8266-build-from:2.0

LABEL maintainer="Piers Finlayson <piers@piersandkatie.com>"

LABEL description="Piers's General Build Container"

#
# This container supports C and Rust, and supports cross compuilation from
# the host to x86-64, ARMv7 and ARMv6 platforms, allowing standalone apps
# to be compiled which can run in empty containers (i.e. FROM scratch).
#
# The original Raspberry Pi and the Zero (W) are ARMv6 (with hard floating
# point support).
#
# The newer Pis are ARMv7.
#
# The most complicated bit here is building the versions of GCC that support
# MUSL libc to enable completely standalone apps (that don't rely on libc
# being available).
#
# Custom versions of OpenSSL are also built for the various platforms.
# Udate OPENSSL_VERSION below to change the version.
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
		curl -sSL https://get.docker.com | sh && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

# Add build user
ADD sudoers /etc/sudoers.d/nopasswd
RUN useradd -ms /bin/bash build && \
    usermod -a -G dialout build && \
		usermod -a -G i2c build && \
    usermod -a -G sudo build && \
    usermod -a -G docker build && \
    mkdir /home/build/builds && \
    chown -R build:build /home/build/builds
USER build
COPY .vimrc /home/build/

# Build ARMv6, ARMv7 and X86_64 versions of MUSL GCC
# bsdtar must be used instead of tar, as untaring can fail in Dockerfiles: https://github.com/docker/hub-feedback/issues/727#issuecomment-299533372
COPY musl-cross-config-armv6 /tmp/
RUN sudo mkdir -p /opt/cross && \
	  sudo chown -R build:build /opt/cross
RUN cd ~/ && \
    git clone https://github.com/richfelker/musl-cross-make.git && \
    cd ~/musl-cross-make && \
    grep MUSL_VER Makefile | awk '{print $3}' | awk '{print $1}' > /tmp/musl_ver.txt && \
    grep GCC_VER Makefile | awk '{print $3}' | awk '{print $1}' > /tmp/musl_gcc_ver.txt && \
    cp /tmp/musl-cross-config-armv6 ./config.mak && \
    sudo rm -f /tmp/musl-cross-config-arvm6 && \
    sudo mv /bin/tar /bin/tar.orig && \
    sudo cp /usr/bin/bsdtar /bin/tar && \
    make install && \
    sudo rm /bin/tar && \
    sudo mv /bin/tar.orig /bin/tar && \
    cd ~/ && \
    sudo rm -fr ~/musl-cross-make
COPY musl-cross-config-armv7 /tmp/
RUN	cd ~/ && \
    rm -fr musl-cross-make && \
    git clone https://github.com/richfelker/musl-cross-make.git && \
    cd ~/musl-cross-make && \
    cp /tmp/musl-cross-config-armv7 ./config.mak && \
    sudo rm -f /tmp/musl-cross-config-arvm7 && \
    sudo mv /bin/tar /bin/tar.orig && \
    sudo cp /usr/bin/bsdtar /bin/tar && \
    make install && \
    sudo rm /bin/tar && \
    sudo mv /bin/tar.orig /bin/tar && \
    cd ~/ && \
    sudo rm -fr ~/musl-cross-make
COPY musl-cross-config-x86_64 /tmp/
RUN	cd ~/ && \
    rm -fr musl-cross-make && \
    git clone https://github.com/richfelker/musl-cross-make.git && \
    cd ~/musl-cross-make && \
    cp /tmp/musl-cross-config-x86_64 ./config.mak && \
    sudo rm -f /tmp/musl-cross-config-x86_64 && \
    sudo mv /bin/tar /bin/tar.orig && \
    sudo cp /usr/bin/bsdtar /bin/tar && \
    make install && \
    sudo rm /bin/tar && \
    sudo mv /bin/tar.orig /bin/tar && \
    cd ~/ && \
    sudo rm -fr ~/musl-cross-make
RUN sudo ln -s /opt/cross/armv6/bin/arm-linux-musleabihf-gcc /usr/local/bin/armv6-linux-musleabihf-gcc && \
    sudo ln -s /opt/cross/armv7/bin/arm-linux-musleabihf-gcc /usr/local/bin/armv7-linux-musleabihf-gcc && \
    sudo ln -s /opt/cross/x86_64/bin/x86_64-linux-musl-gcc /usr/local/bin/x86_64-linux-musl-gcc

# Get OpenSSL
ENV TMP_OPENSSL_DIR=/opt/openssl
RUN sudo mkdir -p $TMP_OPENSSL_DIR && \
	  sudo chown -R build:build /opt/openssl
ENV OPENSSL_VERSION=1.0.2q
RUN cd $TMP_OPENSSL_DIR && \
    wget https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz && \
    tar xzf openssl-$OPENSSL_VERSION.tar.gz && \
    rm openssl-$OPENSSL_VERSION.tar.gz && \
    mv openssl-$OPENSSL_VERSION openssl-src

# X86_64 GNU
ENV PLATFORM=x86_64-linux-gnu
ENV TARGET_CONFIGURE_FLAGS="no-shared no-zlib -fPIC linux-x86_64"
ENV TARGET_DIR=$TMP_OPENSSL_DIR/openssl-$PLATFORM
RUN cd ~/ && \
    cp -pr $TMP_OPENSSL_DIR/openssl-src working && \
    cd working && \
    env CC=$PLATFORM-gcc ./Configure --openssldir=$TARGET_DIR $TARGET_CONFIGURE_FLAGS && \
    make depend && \
    make install && \
    cd ~/ && \
    rm -fr working
ENV X86_64_UNKNOWN_LINUX_GNU_OPENSSL_DIR=$TARGET_DIR
ENV X86_64_UNKNOWN_LINUX_GNU_OPENSSL_LIB_DIR=$TARGET_DIR/lib
ENV X86_64_UNKNOWN_LINUX_GNU_OPENSSL_INCLUDE_DIR=$TARGET_DIR/include

# X86_64 MUSL
ENV PLATFORM=x86_64-linux-musl
ENV TARGET_CONFIGURE_FLAGS="no-shared no-zlib -fPIC linux-x86_64"
ENV TARGET_DIR=$TMP_OPENSSL_DIR/openssl-$PLATFORM
ENV CC_x86_64_unknown_linux_musl=$PLATFORM-gcc
RUN cd ~/ && \
    cp -pr $TMP_OPENSSL_DIR/openssl-src working && \
    cd working && \
    env CC=$CC_x86_64_unknown_linux_musl ./Configure --openssldir=$TARGET_DIR $TARGET_CONFIGURE_FLAGS && \
    make depend && \
    make install && \
    cd ~/ && \
    rm -fr working
ENV X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_DIR=$TARGET_DIR
ENV X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_LIB_DIR=$TARGET_DIR/lib
ENV X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_INCLUDE_DIR=$TARGET_DIR/include

# ARMv7 GNU
ENV PLATFORM=armv7-linux-gnueabihf
ENV TARGET_CONFIGURE_FLAGS="no-shared no-zlib -fPIC linux-armv4 -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard"
ENV TARGET_DIR=$TMP_OPENSSL_DIR/openssl-$PLATFORM
RUN cd ~/ && \
    cp -pr $TMP_OPENSSL_DIR/openssl-src working && \
    cd working && \
    env CC=arm-linux-gnueabihf-gcc ./Configure --openssldir=$TARGET_DIR $TARGET_CONFIGURE_FLAGS && \
    make depend && \
    make install && \
    cd ~/ && \
    rm -fr working
ENV ARMV7_UNKNOWN_LINUX_GNUEABIHF_OPENSSL_DIR=$TARGET_DIR
ENV ARMV7_UNKNOWN_LINUX_GNUEABIHF_OPENSSL_LIB_DIR=$TARGET_DIR/lib
ENV ARMV7_UNKNOWN_LINUX_GNUEABIHF_OPENSSL_INCLUDE_DIR=$TARGET_DIR/include

# ARMv7 MUSL
ENV PLATFORM=armv7-linux-musleabihf
ENV TARGET_CONFIGURE_FLAGS="no-shared no-zlib -fPIC linux-armv4 -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard"
ENV TARGET_DIR=$TMP_OPENSSL_DIR/openssl-$PLATFORM
ENV CC_armv7_unknown_linux_musleabihf=$PLATFORM-gcc
RUN cd ~/ && \
    cp -pr $TMP_OPENSSL_DIR/openssl-src working && \
    cd working && \
    env CC=$CC_armv7_unknown_linux_musleabihf ./Configure --openssldir=$TARGET_DIR $TARGET_CONFIGURE_FLAGS && \
    make depend && \
    make install && \
    cd ~/ && \
    rm -fr working
ENV ARMV7_UNKNOWN_LINUX_MUSLEABIHF_OPENSSL_DIR=$TARGET_DIR
ENV ARMV7_UNKNOWN_LINUX_MUSLEABIHF_OPENSSL_LIB_DIR=$TARGET_DIR/lib
ENV ARMV7_UNKNOWN_LINUX_MUSLEABIHF_OPENSSL_INCLUDE_DIR=$TARGET_DIR/include

# ARMv6 GNU
ENV PLATFORM=armv6-linux-gnueabihf
ENV TARGET_CONFIGURE_FLAGS="no-shared no-zlib -fPIC linux-armv4 -march=armv6 -marm -mfpu=vfp"
ENV TARGET_DIR=$TMP_OPENSSL_DIR/openssl-$PLATFORM
RUN cd ~/ && \
    cp -pr $TMP_OPENSSL_DIR/openssl-src working && \
    cd working && \
    env CC=arm-linux-gnueabihf-gcc ./Configure --openssldir=$TARGET_DIR $TARGET_CONFIGURE_FLAGS && \
    make depend && \
    make install && \
    cd ~/ && \
    rm -fr working
ENV ARM_UNKNOWN_LINUX_GNUEABIHF_OPENSSL_DIR=$TARGET_DIR
ENV ARM_UNKNOWN_LINUX_GNUEABIHF_OPENSSL_LIB_DIR=$TARGET_DIR/lib
ENV ARM_UNKNOWN_LINUX_GNUEABIHF_OPENSSL_INCLUDE_DIR=$TARGET_DIR/include

# ARMv6 MUSL
ENV PLATFORM=armv6-linux-musleabihf
ENV TARGET_CONFIGURE_FLAGS="no-shared no-zlib -fPIC linux-armv4 -march=armv6 -marm -mfpu=vfp"
ENV TARGET_DIR=$TMP_OPENSSL_DIR/openssl-$PLATFORM
ENV CC_arm_unknown_linux_musleabihf=$PLATFORM-gcc
RUN cd ~/ && \
    cp -pr $TMP_OPENSSL_DIR/openssl-src working && \
    cd working && \
    env CC=$CC_arm_unknown_linux_musleabihf ./Configure --openssldir=$TARGET_DIR $TARGET_CONFIGURE_FLAGS && \
    make depend && \
    make install && \
    cd ~/ && \
    rm -fr working
ENV ARM_UNKNOWN_LINUX_MUSLEABIHF_OPENSSL_DIR=$TARGET_DIR
ENV ARM_UNKNOWN_LINUX_MUSLEABIHF_OPENSSL_LIB_DIR=$TARGET_DIR/lib
ENV ARM_UNKNOWN_LINUX_MUSLEABIHF_OPENSSL_INCLUDE_DIR=$TARGET_DIR/include

# Install Rust
# - Clippy not available on arm
WORKDIR /home/build/
RUN cd /home/build && \
    /usr/bin/wget https://sh.rustup.rs -O rust.sh && \
		/bin/bash rust.sh -y --default-toolchain stable && \
		rm /home/build/rust.sh
ENV PATH="/home/build/.cargo/bin:/usr/local/musl/bin:${PATH}"
RUN rustup target add x86_64-unknown-linux-gnu && \
    rustup target add armv7-unknown-linux-gnueabihf && \
    rustup target add arm-unknown-linux-gnueabihf && \
    rustup target add x86_64-unknown-linux-musl && \
		rustup target add armv7-unknown-linux-musleabihf && \
		rustup target add arm-unknown-linux-musleabihf && \
    cargo install mdbook && \
    rustup component add rustfmt && \
    rustup component add clippy; exit 0
RUN echo "[target.x86_64-unknown-linux-gnu]\nlinker = \"x86_64-linux-gnu-gcc\"\n" >> /home/build/.cargo/config && \
    echo "[target.x86_64-unknown-linux-musl]\nlinker = \"x86_64-linux-musl-gcc\"\n" >> /home/build/.cargo/config && \
		echo "[target.armv7-unknown-linux-gnueabihf]\nlinker = \"arm-linux-gnueabihf-gcc\"\n" >> /home/build/.cargo/config && \
		echo "[target.armv7-unknown-linux-musleabihf]\nlinker = \"armv7-linux-musleabihf-gcc\"\n" >> /home/build/.cargo/config && \
    echo "[target.arm-unknown-linux-gnueabihf]\nlinker = \"arm-linux-gnueabihf-gcc\"\n" >> /home/build/.cargo/config && \
		echo "[target.arm-unknown-linux-musleabihf]\nlinker = \"armv6-linux-musleabihf-gcc\"\n" >> /home/build/.cargo/config

# Finish up
USER root
ADD VERSION /
RUN echo "Container version $(cat /VERSION)" > /VERSION && \
    echo "OpenSSL version" $OPENSSL_VERSION >> /VERSION && \
		echo "$(su - build -c 'rustc --version')" >> /VERSION && \
		echo "$(docker --version)" >> /VERSION && \
		echo "MUSL version $(cat /tmp/musl_ver.txt|awk 'NR == 1')" >> /VERSION && \
		echo "MUSL GCC version $(cat /tmp/musl_gcc_ver.txt|awk 'NR == 1')" >> /VERSION && \
		rm /tmp/musl_ver.txt /tmp/musl_gcc_ver.txt

USER build
VOLUME ["/home/build/builds"]
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
