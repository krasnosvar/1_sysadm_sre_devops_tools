#узнать где хранятся логи контейнера
docker inspect --format='{{.LogPath}}' container
