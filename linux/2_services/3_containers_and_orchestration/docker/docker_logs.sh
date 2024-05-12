# https://docs.docker.com/config/containers/logging/configure/
docker info --format '{{.LoggingDriver}}'

#узнать где хранятся логи контейнера "alertmanager"
docker inspect --format='{{.LogPath}}' alertmanager

