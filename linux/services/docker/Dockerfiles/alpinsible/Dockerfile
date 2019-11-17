FROM alpine:latest

RUN apk add --no-cache \
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
&& rm -rf /var/cache/* && rm -rf /root/.cache/*
RUN if [ ! -e /usr/bin/pip ]; then ln -s /usr/bin/pip3 /usr/bin/pip ; fi && \
if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi
