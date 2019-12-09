# Not using 'gcc' as base image because of problem with 'gfortran':
# https://github.com/docker-library/gcc/issues/57
# FROM gcc
FROM debian:buster

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
      bsdmainutils \
      build-essential \
      libdb++-dev \
      libboost-all-dev \
      libcurl4-openssl-dev \
      libssl-dev \
      libz-dev \
      pkg-config \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/

COPY . /usr/src/gridcoin/
WORKDIR /usr/src/gridcoin/

# @todo: solve message:
# configure: error: Found Berkeley DB other than 4.8, required for portable wallets (--with-incompatible-bdb to ignore or --disable-wallet to disable wallet functionality)
RUN \
  ./autogen.sh && \
  ./configure --with-incompatible-bdb && \
  make && \
  make install

ENTRYPOINT [ "gridcoinresearchd" ]
