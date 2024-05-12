# Собирать сами образы мы будем с помощью инструмента Kaniko от Google. 
# А почему бы не использовать для создания образов обычную команду Docker? 
# В том, чтобы использовать Kaniko, есть смысл. Объясняю.
# Для эффективной сборки Docker использует кэш, который позволяет не пересобирать заново те слои в образе, в которых ничего не менялось. 
# Но. Ты используешь GitLab Runner в Kubernetes, который на каждую задачу создает новый контейнер. 
# Из-за этого кэш самой сборки никогда не сохранится: после выполнения задачи всё удаляется. 
# Kaniko позволит тебе сохранять и скачивать кэш сборки в сторонних хранилищах вроде registry или S3.


# cd to Dockerfile_dir
# https://blog.csanchez.org/2020/09/15/building-docker-images-with-kaniko-pushing-to-docker-registries/
DOCKER_USERNAME=[...]
DOCKER_PASSWORD=[...]
AUTH=$(echo -n "${DOCKER_USERNAME}:${DOCKER_PASSWORD}" | base64)
cat << EOF > config.json
{
    "auths": {
        "https://index.docker.io/v1/": {
            "auth": "${AUTH}"
        }
    }
}

docker run \                                                                                               
  -v $(pwd):/workspace \
  -v ~/.docker/config.json:/kaniko/.docker/config.json \
  gcr.io/kaniko-project/executor:latest \
  --dockerfile=Dockerfile \
  --context=/workspace \
  --destination=krasnosvar/alpinsible:070722
