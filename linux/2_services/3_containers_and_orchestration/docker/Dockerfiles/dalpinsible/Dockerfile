#docker in docker
#https://stackoverflow.com/questions/54099218/how-can-i-install-docker-inside-an-alpine-container
#docker run -d -v "/var/run/docker.sock:/var/run/docker.sock:rw" dalpinsible:latest docker run hello-world
#Dockerfile v2
#docker build -t krasnosvar/dalpinsible:psql .

FROM alpine:latest
LABEL authors="krasnosvar"
 
RUN apk add --no-cache --update docker openrc \
    openssh-client \
    sshpass \
    rsync \
    python3 \
    build-base \
    python3-dev \
    libffi-dev \
    openssl-dev \
    curl \
    tzdata \
    py3-pip \
    cargo \
    rust \
    git \
    bash \
    postgresql-client \
&& pip3 install --upgrade pip \
&& pip3 install --no-cache-dir setuptools wheel ansible cx-Oracle\
    && apk del \
    cargo \
    rust \
    python3-dev \
    libffi-dev \
    build-base \
    openssl-dev \
    gcc \
    musl-dev \
    linux-headers \
    build-base \
    g++ \
&& rm -rf /var/cache/* && rm -rf /root/.cache/*
RUN if [ ! -e /usr/bin/pip ]; then ln -s /usr/bin/pip3 /usr/bin/pip ; fi && \
if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi

RUN rc-update add docker boot
