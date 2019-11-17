#!/usr/bin/env bash
find /etc/ -type f -exec sed -i 's/10.8.181.175*/10.5.10.147/g' {} + 2> /dev/null
find /etc/ -type f -exec sed -i 's/10.8.181.77*/10.5.10.148/g' {} + 2> /dev/null
find /etc/ -type f -exec sed -i 's/10.8.181.95*/10.5.10.149/g' {} + 2> /dev/null
find /etc/ -type f -exec sed -i 's/10.8.181.109*/10.5.10.150/g' {} + 2> /dev/null
find /etc/ -type f -exec sed -i 's/10.8.181.130*/10.5.10.151/g' {} + 2> /dev/null
find /etc/ -type f -exec sed -i 's/10.8.181.193*/10.5.10.152/g' {} + 2> /dev/null
find /etc/ -type f -exec sed -i 's/10.8.181.227*/10.5.10.153/g' {} + 2> /dev/null
find /etc/ -type f -exec sed -i 's/10.8.37.195*/10.5.10.154/g' {} + 2> /dev/null
find /etc/ -type f -exec sed -i 's/10.8.37.241*/10.5.10.155/g' {} + 2> /dev/null
find /etc/ -type f -exec sed -i 's/10.8.37.51*/10.5.10.156/g' {} + 2> /dev/null
find /etc/ -type f -exec sed -i 's/10.8.152.62*/10.5.10.157/g' {} + 2> /dev/null
find /etc/ -type f -exec sed -i 's/adtest1*/adldap/g' {} + 2> /dev/null

find /opt/ -type f -exec sed -i 's/10.8.181.175*/10.5.10.147/g' {} + 2> /dev/null
find /opt/ -type f -exec sed -i 's/10.8.181.77*/10.5.10.148/g' {} + 2> /dev/null
find /opt/ -type f -exec sed -i 's/10.8.181.95*/10.5.10.149/g' {} + 2> /dev/null
find /opt/ -type f -exec sed -i 's/10.8.181.109*/10.5.10.150/g' {} + 2> /dev/null
find /opt/ -type f -exec sed -i 's/10.8.181.130*/10.5.10.151/g' {} + 2> /dev/null
find /opt/ -type f -exec sed -i 's/10.8.181.193*/10.5.10.152/g' {} + 2> /dev/null
find /opt/ -type f -exec sed -i 's/10.8.181.227*/10.5.10.153/g' {} + 2> /dev/null
find /opt/ -type f -exec sed -i 's/10.8.37.195*/10.5.10.154/g' {} + 2> /dev/null
find /opt/ -type f -exec sed -i 's/10.8.37.241*/10.5.10.155/g' {} + 2> /dev/null
find /opt/ -type f -exec sed -i 's/10.8.37.51*/10.5.10.156/g' {} + 2> /dev/null
find /opt/ -type f -exec sed -i 's/10.8.152.62*/10.5.10.157/g' {} + 2> /dev/null
find /opt/ -type f -exec sed -i 's/adtest1*/adldap/g' {} + 2> /dev/null