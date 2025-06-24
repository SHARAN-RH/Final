FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    openssh-server \
    sudo \
    vim \
    curl \
    gnupg2 \
    software-properties-common && \
    pip3 install ansible && \
    mkdir /var/run/sshd

RUN useradd -m ansible && echo 'ansible:ansible' | chpasswd && adduser ansible sudo

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
