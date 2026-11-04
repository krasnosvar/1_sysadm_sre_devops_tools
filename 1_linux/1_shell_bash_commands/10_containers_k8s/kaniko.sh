# We will build images ourselves using Google's Kaniko tool. 
# Why not use regular Docker command for creating images?
# There is sense in using Kaniko. Let me explain.
# For efficient building Docker uses cache, which allows not to rebuild layers in image where nothing has changed. 
# But. You use GitLab Runner in Kubernetes, which creates new container for each task.
# Because of this build cache will never be saved: after task execution everything is deleted. 
# Kaniko will allow you to save and download build cache in external storages like registry or S3.


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
