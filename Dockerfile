FROM hypriot/rpi-alpine:latest

MAINTAINER Justin Brehm <jhbrehm@gmail.com>

ARG UNIFI_VERSION=5.6.29

RUN \
   
  apk --update add \ 
    --no-cache \
    openjdk8-jre &&\

  # Install tzdata
  apk add \
    --no-cache \
    tzdata && \

  # Install SSL
  apk add \
    --no-cache \
    ca-certificates \
    openssl && \
    
  rm /var/cache/apk/*

RUN \

  # Install unifi
  wget https://www.ubnt.com/downloads/unifi/${UNIFI_VERSION}/UniFi.unix.zip \
    -O /tmp/unifi.zip && \
    unzip /tmp/unifi.zip -d /tmp/ && \
    mv /tmp/UniFi /usr/lib/unifi && \

  # Remove unnecessary files
  rm -rf \
    /usr/lib/unifi/lib/native/Linux/amd64 \
    /usr/lib/unifi/lib/native/Mac \
    /usr/lib/unifi/lib/native/Windows && \

  # Cleanup temporary folder
  rm -rf /tmp/*

COPY rootfs /

RUN chmod 0744 /usr/local/bin/docker_entrypoint.sh

ENV JAVA_HOME /usr/lib/jvm/default-jvm/jre

VOLUME /usr/lib/unifi/data

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
