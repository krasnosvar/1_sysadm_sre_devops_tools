1. создать директорию в gitlab
2. сделать git clone(ssh ссылка появится в gitlab)
3. для пуша изменений:
#git add .
#git commit -m "message"
#git push

---------------------------------------------------------------------------------------------
#gitlab-api
curl --insecure https://coderepo.corp.domain.ru/api/v4/projects | python -m json.tool> gitlab_api.json


#make exiting user admin
#How to setup admin user with gitlab with LDAP authentication?
https://stackoverflow.com/questions/11761396/how-to-setup-admin-user-with-gitlab-with-ldap-authentication
#enter ruby on rails console
gitlab-rails console -e production
#find user and add him to admins
User.find_by_email("krasnosvarov_dn@magnit.ru") do |i|
    i.admin = true
    i.save
end
#or
gitlab-rails console production
u = User.where(id: 1).first
u.admin = true
u.save!
exit

#How to reset your root password 
https://docs.gitlab.com/ce/security/reset_root_password.html


Rails add user in rails console
https://gist.github.com/tacettin/8182358



#verify user without e-mail confirmation
#https://gist.github.com/macdja38/3d62d4f251bd7c46f0128bb6a9d35544
#source installation
gitlab-rails console production
#Omnibus
gitlab-rails console
#Find your user via mail
user = User.find_by(email: "youroldemail@example.com")
#or via name(login)
user = User.find_by(name: "remote_ximilab1")
#Optionally change the user's email with 
user.email = "yournewemail@example.com" Then run user.save!
#Get the user's token with 
user.confirmation_token

https://PutYourGitlabHere/users/confirmation?confirmation_token=PutYourTokenHere
---------------------------------------------------------------------------------------------

#регистрация gitlab-runner
1. add coderepo(domain local gitlab) to no_proxy in /etc/environment
NO_PROXY="localhost,127.0.0.0/24,coderepo.corp.domain.ru"
no_proxy="localhost,127.0.0.0/24,coderepo.corp.domain.ru"
2. export certifitate fron coderepo site with firefox
3. copy-rename certifitate to gitlab-runner directory 
mv /home/den/Downloads/v00coderepo_corp_domain_ru.crt /etc/gitlab-runner/certs/coderepo_corp_domain_ru.crt
4. register gitlab-runner with command
sudo gitlab-runner register --tls-ca-file /etc/gitlab-runner/certs/coderepo_corp_domain_ru.crt

#config Gitlab-runner 12
root@it-krasnosvarov:~# cat /etc/gitlab-runner/config.toml
concurrent = 1
check_interval = 0

[[runners]]
  environment = ["GIT_SSL_NO_VERIFY=1"]
  name = "it-kras-comp-docker-only"
  url = "https://coderepo.corp.domain.ru/"
  token = "token-here"
  executor = "docker"
  tls-ca-file = "/etc/gitlab-runner/certs/coderepo.corp.domain.ru.crt"
  [runners.docker]
    tls_verify = false
    image = "v00rpm-dr.corp.domain.ru/dockerhub/alpine:latest"
    privileged = false
    disable_cache = false
    volumes = ["/cache"]
    shm_size = 0
  [runners.cache]
  

#add registry to coderepotst
mkdir -p /etc/docker/certs.d/v00rpm-dr.corp.domain.ru/
cp /home/krasnosvarov_dn/v00rpm-dr_corp_domain_ru.crt /etc/docker/certs.d/v00rpm-dr.corp.domain.ru/
cd /etc/docker/certs.d/v00rpm-dr.corp.domain.ru/
cp v00rpm-dr_corp_domain_ru.crt ca.crt
docker pull v00rpm-dr.corp.domain.ru/dockerhub/registry
docker images
docker run -d -p 5000:5000 --restart=always --name registry v00rpm-dr.corp.domain.ru/dockerhub/registry
docker ps -a

#add image to local-docker-registry
docker pull v00rpm-dr.corp.domain.ru/dockerhub/krasnosvar-alpinsible2:latest
docker images
docker tag v00rpm-dr.corp.domain.ru/dockerhub/krasnosvar-alpinsible2 localhost:5000/alpinsible2
docker push localhost:5000/alpinsible2
docker images


#start gitlab-docker-container
sudo docker run --detach \
  --hostname gitlab.example.com \
  --publish 443:443 --publish 80:80 --publish 22:2222 \
  --name gitlab \
  --restart always \
  --volume /srv/gitlab/config:/etc/gitlab \
  --volume /srv/gitlab/logs:/var/log/gitlab \
  --volume /srv/gitlab/data:/var/opt/gitlab \
  v00rpm-dr.corp.domain.ru/dockerhub/gitlab-gitlab-ce


#docker-compose.yml
web:
  image: 'v00rpm-dr.corp.domain.ru/dockerhub/gitlab-gitlab-ce:latest'
  restart: always
  hostname: 'gitlab.example.com'
  environment:
    GITLAB_OMNIBUS_CONFIG: |
      external_url 'https://gitlab.example.com'
      # Add any other gitlab.rb configuration here, each on its own line
  ports:
    - '80:80'
    - '443:443'
    - '22:2222'
  volumes:
    - '/srv/gitlab/config:/etc/gitlab'
    - '/srv/gitlab/logs:/var/log/gitlab'
    - '/srv/gitlab/data:/var/opt/gitlab'