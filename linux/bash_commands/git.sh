#Самые типичные ошибки и вопросы, связанные с Git, и удобные способы их решения
https://tproger.ru/translations/most-common-git-screwupsquestions-and-solutions/

#global config
git config --global user.name "krasnosvar"
git config --global user.email "krasnosvar@gmail.com"
#add remotes
git remote add github git@github.com:krasnosvar/git.git
git remote add bitbucket git@bitbucket.org:krasnosvar/git.git

#add to one remote several git-repos
#Добавляем
git remote add "all" git@git@github.com:krasnosvar/git.git
git remote set-url --add --push "all" git@github.com:krasnosvar/git.git
git remote set-url --add --push "all" git@bitbucket.org:krasnosvar/git.git
git remote set-url --add --push "all" git@git@gitlab.com:krasnosvar/git.git
#Отправляем
git push all

#скопировать проект в пустой удаленный репозиторий
cd project_folder
git init 
git remote add origin git@gitlab.ru:project/env-menu.git
git push -u origin master


#Git — Удалить Все Коммиты — Очистить Историю в Git
https://www.shellhacks.com/ru/git-remove-all-commits-clear-git-history-local-remote/
#Создайте временную ветку и перейдите в нее:
$ git checkout --orphan temp_branch
#Добавьте все файлы в новую ветку и сделайте коммит изменений:
$ git add -A
$ git commit -am "The first commit"
#Удалите master-ветку:
$ git branch -D master
#Переименуйте временную ветку в master:
$ git branch -m master
#Принудительно обновите удаленный репозиторий:
$ git push -f origin master

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

#При добавлении в .gitignore файлов или папок, необходимо обнулить кэш гита
#выполнив команду( -r значит рекурсивно в папке)
git rm -r --cached scripts/menu/*

#если в ремоте и локале разные коммиты и не дает скачать-отправить
git pull https://gitlab.cserv.local/den/docker-hello-world.git --allow-unrelated-histories

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


#GIT_WITH_PROXY
git config --global http.proxy http://username:password@proxy.example.com:8080
git config --global https.proxy http://username:password@proxy.example.com:8080

#switch to commit
git checkout e8b3ec06b

#GIT TAG
#add tag "v0.1" to commit "3b3decb"
git tag -a v0.1 3b3decb
#push tags to remote
git push --tags

#MARKDOWN
#Гайд по Markdown
https://guides.github.com/features/mastering-markdown/
#Шаблон хорошего Readme
https://gist.github.com/PurpleBooth/109311bb0361f32d87a2

#GIT PULL
#git pull to pecific branch
git -C /var/www/source/ pull git@gitlab.com:krasnosvar/jenkins_2.git

#git pull all branches from remote
git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
git fetch --all
git pull --all

#git push not master branch(for example, develop branch)
git push -u origin develop


#Объединить коммиты(6 - по кол-ву коммитов до которого надо объединить):
#https://git-scm.com/book/ru/v2/Инструменты-Git-Исправление-истории
#https://ru.stackoverflow.com/questions/462251/Как-объединить-несколько-коммитов-в-один
git log --pretty=oneline 
git rebase -i HEAD~6
git log --pretty=oneline 
#объединить коммиты с первым(2 - по общему кол-ву коммитов):
git reset --hard HEAD~2
git merge --squash HEAD@{1}


#ERRORS
#if
fatal: unable to access 'https://git.mycompany.com/myuser/myrepo.git/': server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
#then
https://fabianlee.org/2019/01/28/git-client-error-server-certificate-verification-failed/
#if file is too big to push to github, deleted but still in git-cache
git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch linux/services/terraform/libvirt/images/focal-server-cloudimg-amd64-disk-kvm.img'


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
