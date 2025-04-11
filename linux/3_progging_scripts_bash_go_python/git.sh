# Semantic Versioning 2.0.0
# https://semver.org/lang/ru/

#MARKDOWN
#Гайд по Markdown
https://guides.github.com/features/mastering-markdown/
#Шаблон хорошего Readme
https://gist.github.com/PurpleBooth/109311bb0361f32d87a2


#Самые типичные ошибки и вопросы, связанные с Git, и удобные способы их решения
https://tproger.ru/translations/most-common-git-screwupsquestions-and-solutions/

#files
#keep blank dirs
.gitkeep
#ignore files
.gitignore


#GUT CONFIG
#global config
git config --global user.name "krasnosvar"
git config --global user.email "krasnosvar@gmail.com"
git config --global color.ui auto
git config --global core.editor "vim"
#ignore ssl certs
git config --global http.sslverify false

#config in repo
cd git_repo
git config user.name "krasnosvar"
git config user.email "krasnosvar@gmail.com"
#add remotes
git remote add github git@github.com:krasnosvar/git.git
git remote add bitbucket git@bitbucket.org:krasnosvar/git.git
#GIT_WITH_PROXY
git config --global http.proxy http://username:password@proxy.example.com:8080
git config --global https.proxy http://username:password@proxy.example.com:8080
#PROXY
#https://stackoverflow.com/questions/24907140/git-returns-http-error-407-from-proxy-after-connect
git config --global http.sslVerify false
git config --global https.sslVerify false
git config --global http.proxy http://user:pass@yourproxy:port
git config --global https.proxy http://user:pass@yourproxy:port
#
git config --global --unset http.proxy
git config --global --unset https.proxy
#
git config --global http.proxyAuthMethod 'basic'
#use non-default ssh-key in repo
cd git_repo
git config core.sshCommand "ssh -i ~/.ssh/id_rsa_leg5"


#add to one remote several git-repos
#add
git remote add "all" git@git@github.com:krasnosvar/git.git
git remote set-url --add --push "all" git@github.com:krasnosvar/git.git
git remote set-url --add --push "all" git@bitbucket.org:krasnosvar/git.git
git remote set-url --add --push "all" git@git@gitlab.com:krasnosvar/git.git
#push to all simultaneously
git push all


#GIT CLONE
#git clone to dir ( clone code exactly to dir )
git clone  some-gitlab-repo-server.com:kb/repo-group/repo.git /var/dir
#git clone specific branch, not master
git clone --branch "release/4.5.0" some-gitlab-repo-server.com:kb/repo-group/repo.git
# git clone only one dir from repo with many dirs
# from repo helm-charts clone only "charts/kube-prometheus-stack" dir ( so --depth 2)
# https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository
git clone \
  --depth 2  \
  --filter=blob:none  \
  --sparse \
  https://github.com/prometheus-community/helm-charts \
;
cd helm-charts
git sparse-checkout set kube-prometheus-stack


#GIT PUSH
#create new branch and push to github or gitlab
git checkout -b release/2.0
git push --set-upstream origin release/2.0
#скопировать проект в пустой удаленный репозиторий
cd project_folder
git init 
git remote add origin git@gitlab.ru:project/env-menu.git
git push -u origin master
#git push new local branch to server
#https://stackoverflow.com/questions/2765421/how-do-i-push-a-new-local-branch-to-a-remote-git-repository-and-track-it-too
git checkout -b <branch>
git push -u origin <branch>


#GIT PULL
#git pull to specific branch
git -C /var/www/source/ pull git@gitlab.com:krasnosvar/jenkins_2.git

#git pull all branches from remote
git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
git fetch --all
git pull --all

#git push not master branch(for example, develop branch)
git push -u origin develop


#GITIGNORE
#При добавлении в .gitignore файлов или папок, необходимо обнулить кэш гита
#выполнив команду( -r значит рекурсивно в папке)
git rm -r --cached scripts/menu/*


#GIT COMMITS
#switch to commit
git checkout e8b3ec06b

#Объединить коммиты(6 - по кол-ву коммитов до которого надо объединить):
#https://git-scm.com/book/ru/v2/Инструменты-Git-Исправление-истории
#https://ru.stackoverflow.com/questions/462251/Как-объединить-несколько-коммитов-в-один
git log --pretty=oneline 
git rebase -i HEAD~6
git log --pretty=oneline 
#объединить коммиты с первым(2 - по общему кол-ву коммитов):
git reset --hard HEAD~2
git merge --squash HEAD@{1}

#Git — Удалить Все Коммиты — Очистить Историю в Git
https://www.shellhacks.com/ru/git-remove-all-commits-clear-git-history-local-remote/
#Создайте временную ветку и перейдите в нее:
git checkout --orphan temp_branch
#Добавьте все файлы в новую ветку и сделайте коммит изменений:
git add -A
git commit -am "The first commit"
#Удалите master-ветку:
git branch -D master
#Переименуйте временную ветку в master:
git branch -m master
#Принудительно обновите удаленный репозиторий:
git push -f origin master

#Отмена изменений
#отмена не добавленного, но измененного файла
git reset HEAD hello.html
#отмена добавленного(git add)файла
git checkout hello.html
#отмена последнего коммита(с созданием нового коммита REVERT)
git revert HEAD --no-edit
#удаление коммитов насовсем
#1. затегировать последние изменения, которые надо удалить, затегировать изменения, на которые надо откатиться
git tag oops
git reset --hard v1
git tag -d oops
git log --pretty=oneline --all #проверка изменений
#Внесение изменений в коммит
git commit --amend -m "Add an author/email comment"


#GIT BRANCH
#branch list
git branch
git branch -v # with last commit
#create branch and go to it
git checkout -b iss53
#or
git branch iss53 && git checkout iss53
#rename branch
git branch --move bad-branch-name corrected-branch-name
#delete branch "testing"
git branch -d testing
#delete on remote
git push origin --delete bad-branch-name
#rename and set upstream
git branch --move master main
git push --set-upstream origin main
git push origin --delete master


#GIT TAG
#add tag "v0.1" to commit "3b3decb"
git tag -a v0.1 3b3decb
#push tags to remote
git push --tags


#GIT LOG
#однострочный формат вывода логов
git log --pretty=oneline
#еще один тип вывода, с датой
git log --all --pretty=format:"%h %cd %s (%an)" --since='7 days ago'
#или
# --pretty="..." — определяет формат вывода.
# %h — укороченный хэш коммита
# %d — дополнения коммита («головы» веток или теги)
# %ad — дата коммита
# %s — комментарий
# %an — имя автора
# --graph — отображает дерево коммитов в виде ASCII-графика
# --date=short — сохраняет формат даты коротким и симпатичным
git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short
#make alias
vi ~/.gitconfig
[alias]
  co = checkout
  hist = log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short
#теперь можно вводить git hist
#Предоставить 3 последних коммита
git log --max-count=3
git log -n 3



# CHERRY PICk
# add only one commit from branch A to branch B
#1. fetch commit hash in brnach A
git checkout branch-A
git log --pretty
# 2. move to branch B and add commit
git checkout branch-B
git cherry-pick 5a8c6b51a779ecf1ee76f0b884b408f4aa3897b9 --no-commit
# 3. commit and push to remote
git add . && git commit -m "added cherry picked commit from A" && git push origin HEAD



#ERRORS
#if
fatal: unable to access 'https://git.mycompany.com/myuser/myrepo.git/': server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
#then
https://fabianlee.org/2019/01/28/git-client-error-server-certificate-verification-failed/
# update CA certificates
sudo apt-get install apt-transport-https ca-certificates -y
sudo update-ca-certificates
openssl s_client -showcerts -servername git.mycompany.com -connect git.mycompany.com:443 </dev/null 2>/dev/null | sed -n -e '/BEGIN\ CERTIFICATE/,/END\ CERTIFICATE/ p'  > git-mycompany-com.pem
cat git-mycompany-com.pem | sudo tee -a /etc/ssl/certs/ca-certificates.crt


#if file is too big to push to github, deleted but still in git-cache
git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch linux/services/terraform/libvirt/images/focal-server-cloudimg-amd64-disk-kvm.img'
#or
#if large file was added
#https://www.deployhq.com/git/faqs/removing-large-files-from-git-history
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch linux/2_services/docker/Dockerfiles/sqlplus/instantclient_21_4/libociei.so' \
  --prune-empty --tag-name-filter cat -- --all

#error: RPC failed; curl 56 GnuTLS recv error (-110): The TLS connection was non-properly terminated.
#git clone https://github.com/theforeman/foreman-ansible-modules.git
git clone  --depth=1 https://github.com/theforeman/foreman-ansible-modules.git

#fatal: refusing to merge unrelated histories
git pull origin master --allow-unrelated-histories

#fatal: unable to access 'https://gitlab.ru/repository.ru.git/': Peer's Certificate has expired
git -c http.sslVerify=false push origin master

#если в ремоте и локале разные коммиты и не дает скачать-отправить
git pull https://gitlab.cserv.local/den/docker-hello-world.git --allow-unrelated-histories
