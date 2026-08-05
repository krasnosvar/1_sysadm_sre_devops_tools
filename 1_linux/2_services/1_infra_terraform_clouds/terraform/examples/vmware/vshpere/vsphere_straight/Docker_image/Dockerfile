#docker build -t krasnosvar/terrasible:wsphere .
# apk add terraform --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
# FROM golang:1.19-rc-alpine3.15 AS terraformbundler
#20072022
FROM golang:alpine3.15 AS terraformbundler
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
    unzip \
    git \
    ca-certificates \
    py3-pip \
    ansible \
    terraform --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
&& apk del py3-pip && apk add py3-pip \
&& pip3 install --upgrade --no-cache-dir pip \
&& pip3 install --no-cache-dir ansible-lint \
&& apk del \
    python3-dev \
    libffi-dev \
    build-base \
    openssl-dev \
    gcc \
    musl-dev \
    linux-headers \
    build-base \
    g++ \
&& rm -rf /var/cache/* && rm -rf /root/.cache/* \
&& rc-update add docker boot \
&& mkdir -p $HOME/.terraform.d/plugin-cache

# RUN if [ ! -e /usr/bin/pip ]; then ln -s /usr/bin/pip3 /usr/bin/pip ; fi && \
# if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
# rc-update add docker boot

# COPY ./terraform.d .
COPY main.tf .
COPY .terraformrc /root/

RUN terraform init
