FROM ubuntu:20.04

#add postgres v14 sources
# https://techviewleo.com/how-to-install-postgresql-database-on-ubuntu/
RUN apt update \
    && apt install wget lsb-release gnupg2 -y \
    && echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt update \
    && apt install -y --no-install-recommends libaio1 python3 python3-pip postgresql-client \
    && pip3 install ansible \
    && rm -rf /var/lib/apt/lists/*

# COPY instantclient_21_4/ instantclient_21_4/
# ENV ORACLE_HOME=/instantclient_21_4
# ENV LD_LIBRARY_PATH="$ORACLE_HOME"
# ENV PATH="$ORACLE_HOME:$PATH"


# docker build -t krasnosvar/ansipsql:u20 . && docker push krasnosvar/ansipsql:u20
