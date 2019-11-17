#Самые типичные ошибки и вопросы, связанные с Git, и удобные способы их решения
https://tproger.ru/translations/most-common-git-screwupsquestions-and-solutions/

git config --global user.name "krasnosvar"
git config --global user.email "krasnosvar@gmail.com"
#add remotes
git remote add github git@github.com:krasnosvar/git.git
git remote add bitbucket git@bitbucket.org:krasnosvar/git.git
#add to one remote several git-repos
git remote set-url --add all git@github.com:krasnosvar/git.git
git remote set-url --add all git@gitlab.com:krasnosvar/git.git
git remote set-url --add all git@bitbucket.org:krasnosvar/git.git

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
