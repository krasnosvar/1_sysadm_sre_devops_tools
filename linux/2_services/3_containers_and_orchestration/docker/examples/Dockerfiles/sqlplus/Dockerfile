# u20 image for DB with clients oracle sqlplus and postgres psql and needed packets and ansible for CI-CD

FROM ubuntu:20.04
# https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
# unzip instantclient-basic-linux.x64-21.4.0.0.0dbru.zip
# https://download.oracle.com/otn_software/linux/instantclient/216000/instantclient-basic-linux.x64-21.6.0.0.0dbru.zip
#add postgres v14 sources
# https://techviewleo.com/how-to-install-postgresql-database-on-ubuntu/
RUN apt update \
    && apt install wget lsb-release gnupg2 locales -y \
    && echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt update \
    && apt upgrade -y \
    && apt install -y --no-install-recommends libaio1 python3 python3-pip postgresql-client \
    && pip3 install ansible \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen ru_RU.CP1251

COPY instantclient_21_6/ instantclient_21_6/
ENV ORACLE_HOME=/instantclient_21_6
ENV LD_LIBRARY_PATH="$ORACLE_HOME"
ENV PATH="$ORACLE_HOME:$PATH"



# docker build -t krasnosvar/sqlplus:v21.4 . && docker push krasnosvar/sqlplus:v21.4
# docker build -t krasnosvar/sqlplus:v21.6 . && docker push krasnosvar/sqlplus:v21.6
