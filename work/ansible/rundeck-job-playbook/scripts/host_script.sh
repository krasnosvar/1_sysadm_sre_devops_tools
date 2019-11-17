#on docker:
sshpass -p "r99RsQa1qq5PR8" scp svc_rundeck@coderepotst:/home/rundeck/docker-hello-world.tar .
docker load --input /home/rundeck/docker-hello-world.tar
docker stop web-test
docker run -d --rm --name web-test -p 80:8000 v00rpm-dr.corp.domain.ru/dockerhub/docker-hello-world:$1
