FROM ubuntu:20.04

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get -y update && apt-get -y upgrade && \
        apt-get install -y software-properties-common && \
        add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable && \
        apt-get install -y python3 python3-pip python3-lxml aria2 \
        qbittorrent-nox tzdata p7zip-full p7zip-rar xz-utils curl pv jq \
        ffmpeg wget locales unzip neofetch git make g++ gcc automake \
        autoconf libtool libcurl4-openssl-dev qt5-default \
        libsodium-dev libssl-dev libcrypto++-dev libc-ares-dev \
        libsqlite3-dev libfreeimage-dev swig libboost-all-dev \
        libpthread-stubs0-dev zlib1g-dev libpq-dev libffi-dev
        
# Installing Mega SDK Python Binding
ENV MEGA_SDK_VERSION="3.9.5"
RUN git clone https://github.com/meganz/sdk.git --depth=1 -b v$MEGA_SDK_VERSION ~/home/sdk \
    && cd ~/home/sdk && rm -rf .git \
    && autoupdate -fIv && ./autogen.sh \
    && ./configure --disable-silent-rules --enable-python --with-sodium --disable-examples \
    && make -j$(nproc --all) \
    && cd bindings/python/ && python3 setup.py bdist_wheel \
    && cd dist/ && pip3 install --no-cache-dir megasdk-$MEGA_SDK_VERSION-*.whl 

RUN apt-get -y update && apt-get -y upgrade && apt-get -y autoremove && apt-get -y autoclean
        
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
