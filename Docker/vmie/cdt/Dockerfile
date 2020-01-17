# docker build . -t eos-cdt
FROM ubuntu:18.04

# Arguments that may be overridden by the user
ARG release=v1.7.0

# Install required packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install python openssl ca-certificates curl wget cmake build-essential git && rm -rf /var/lib/apt/lists/*

# git clone 
RUN git clone --recursive https://github.com/eosio/eosio.cdt && \
    cd eosio.cdt && \
    git checkout ${release} && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j10 && \
    make install

