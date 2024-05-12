#docker build -t krasnosvar/terrasible:vra7 .
FROM golang:alpine AS terraformbundler
ENV TERRAVER=v0.14.9
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
&& rm -rf /var/cache/* && rm -rf /root/.cache/* && \
wget https://releases.hashicorp.com/terraform/0.14.9/terraform_0.14.9_linux_amd64.zip && \
unzip terraform_0.14.9_linux_amd64.zip -d /usr/local/bin/ && \
rm -rf terraform_0.14.9_linux_amd64.zip
RUN if [ ! -e /usr/bin/pip ]; then ln -s /usr/bin/pip3 /usr/bin/pip ; fi && \
if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
rc-update add docker boot

COPY ./terraform.d .
