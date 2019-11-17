#https://github.com/crccheck/docker-hello-world
FROM v00rpm-dr.corp.domain.ru/dockerhub/busybox:latest

ADD index.html /www/index.html

EXPOSE 8000
HEALTHCHECK CMD nc -z localhost 8000

# Create a basic webserver and run it until the container is stopped
CMD trap "exit 0;" TERM INT; httpd -p 8000 -h /www -f & wait
#docker run -d --rm --name web-test -p 80:8000 v00rpm-dr.corp.domain.ru/dockerhub/docker-hello-world
