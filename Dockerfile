FROM ubuntu:18.04

RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential wget \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src/mpich
RUN wget -qO- http://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz \
    |tar xfz - -C /usr/local/src/mpich --strip-components=1 \
 && ./configure --disable-fortran --enable-fast=all,O3 --prefix=/usr \
 && make -j$(nproc) \
 && make install \
 && ldconfig \
 && cd / \
 && rm -rf /usr/local/src/mpich
WORKDIR /usr/local/src
COPY hello.c .
RUN mpicc -o /usr/local/bin/hello hello.c
RUN mpirun -n 2 /usr/local/bin/hello
RUN mpirun -n 2 /usr/local/bin/hello 1
