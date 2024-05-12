#### App Headers show
* написано для теста хедеров
* необходимо было видеть какие хедеры отдаются приложению ( какие хедеры видит именно само приложение) при клиентском запросе


1. Приложение возвращает в ответе хедеры что были переданы ему ( хедеры которые видит приложение, после того как к нему обратились)


2. Сборка
```
docker build --no-cache --tag "headers_test:v1" -f Dockerfile . 

docker run -it  -p 5000:5000 headers_test:v1
curl -v http://127.0.0.1:5000 
```


3. Ответы ( примеры)
* локально
```
curl http://127.0.0.1:5000 
x-forwarded-for: None
x-real-ip: None

request.headers:
Host: 127.0.0.1:5000
User-Agent: curl/7.81.0
Accept: */*


```

* в кубе
```
curl -k https://tst-headers.k8sdomain.local     
x-forwarded-for: 10.101.102.103, 10.101.102.99

               x-real-ip: 10.101.102.103

               request.headers: 

               Host: tst-headers.k8sdomain.local
X-Real-Ip: 10.101.102.103
X-Forwarded-For: 10.101.102.103, 10.101.102.99
X-Forwarded-Proto: https,https
X-Forwarded-Host: tst-headers.k8sdomain.local
X-Forwarded-Port: 443
X-Scheme: https
X-Original-Forwarded-For: 10.101.102.103
Accept-Encoding: gzip, br
User-Agent: curl/7.81.0
Accept: */*

```


4. PS
* команда tcpdump,показывающая только хедеры
```
tcpdump -i eth0 -A -s 10240 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)' | egrep --line-buffered "^........(GET |HTTP\/|POST |HEAD )|^[A-Za-z0-9-]+: " | sed -r 's/^........(GET |HTTP\/|POST |HEAD )/\n\1/g'
```
