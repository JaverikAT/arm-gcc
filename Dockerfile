FROM ubuntu:16.04
MAINTAINER Jonas Ahlf <jonas.ahlf@automationtechnology.de>
LABEL Description="Image for building linux kernel and other projects for arm platform inspired by https://hub.docker.com/r/gmacario/build-yocto/dockerfile and https://hub.docker.com/r/stronglytyped/arm-none-eabi-gcc/dockerfile"


# Install dependencies
RUN apt update && \
    apt upgrade -y && \
    apt install -y \
# Development files
      build-essential \
      gcc-arm-linux-gnueabihf \
      gcc-arm-linux-gnueabi \
      openssl libssl-dev \
      u-boot-tools device-tree-compiler python2.7 nano \
      bc \
      git \
      bzip2 \
      wget && \
    apt clean

# Create user "broot" as root user
RUN id broot 2>/dev/null || useradd --uid 1000 --create-home broot

# Create a non-root user that will perform the actual build
RUN id build 2>/dev/null || useradd --uid 30000 --create-home build
RUN apt-get install -y sudo
RUN echo "build ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

#Set locals
RUN apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
        dpkg-reconfigure --frontend=noninteractive locales && \
        update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

USER build
WORKDIR /home/build
CMD "/bin/bash"
