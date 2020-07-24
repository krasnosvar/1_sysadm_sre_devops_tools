#Сравнить построчно
#diff -y Dockerfile Dockerfile_test_diff 
FROM alpine:latest                                              FROM alpine:latest
LABEL authors="krasnosvar@gmail.com"                          | LABEL authors="krasnosvar@yandex.ru"

RUN apk add --no-cache \                                        RUN apk add --no-cache \
    openssh-client \                                                openssh-client \
    sshpass \                                                       sshpass \
    rsync \                                                         rsync \
    python3 \                                                       python3 \
    build-base \                                                    build-base \
    python3-dev \                                                   python3-dev \
    libffi-dev \                                                    libffi-dev \
    openssl-dev \                                                   openssl-dev \
    curl \                                                          curl \
    tzdata \                                                        tzdata \
&& pip3 install --upgrade --no-cache-dir pip \                  && pip3 install --upgrade --no-cache-dir pip \
&& pip3 install --no-cache-dir ansible-lint \                   && pip3 install --no-cache-dir ansible-lint \
&& apk del \                                                    && apk del \
    python3-dev \                                                   python3-dev \
    libffi-dev \                                                    libffi-dev \
    build-base \                                                    build-base \
    openssl-dev \                                                   openssl-dev \
    gcc \                                                           gcc \
    musl-dev \                                                      musl-dev \
    linux-headers \                                                 linux-headers \
    build-base \                                                    build-base \
    g++ \                                                           g++ \
&& rm -rf /var/cache/* && rm -rf /root/.cache/*                 && rm -rf /var/cache/* && rm -rf /root/.cache/*
RUN if [ ! -e /usr/bin/pip ]; then ln -s /usr/bin/pip3 /usr/b   RUN if [ ! -e /usr/bin/pip ]; then ln -s /usr/bin/pip3 /usr/b
if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /   if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /

#С ключом -q просто скажет различаются ли файлы или нет 
#diff -q Dockerfile Dockerfile_test_diff 
Files Dockerfile and Dockerfile_test_diff differ

#Покажет различающиеся строчки
#diff Dockerfile Dockerfile_test_diff 
2c2
< LABEL authors="krasnosvar@gmail.com"
---
> LABEL authors="krasnosvar@yandex.ru"
