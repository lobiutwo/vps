FROM ubuntu:24.04

# System-Updates und SSH installieren
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# SSH-Verzeichnis vorbereiten
RUN mkdir /var/run/sshd

# Benutzer "vpsadmin" anlegen
RUN useradd -rm -d /home/vpsadmin -s /bin/bash -g root -G sudo -u 1000 vpsadmin
RUN echo 'vpsadmin:MeinSicheresPasswort123!' | chpasswd
RUN echo 'vpsadmin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
