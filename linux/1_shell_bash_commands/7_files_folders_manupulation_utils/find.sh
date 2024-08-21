#C помощью find найдите все обычные файлы (без директорий, именованных каналов и других файлов специальных типов) 
#с расширением .so, расположенные в директории /lib и во всех ее поддиректориях. Выведите результат в файл ~/libso.
find /lib -type f -name  "*.so" > ~/libso
#найти модифицированные файлы
find ~ -mmin -9 найдёт модифицированное за последние 9 минут.
find ~ -mmin +9 найдёт модифицированное 9 минут назад и ранее.
#Find DIRECTORY "kernel", find start from /, print no errors 
find / -type d -name "kernel" 2>/dev/null


#FIND exlude dirs
#https://stackoverflow.com/questions/4210042/how-to-exclude-a-directory-in-find-command/49149445
#exlude ONE dir ./misc
find . -path ./misc -prune -false -o -name '*.txt'
#exlude MANY dirs
find / -type d \( -path /mnt/correspond -o -path /mnt/celerra -o -path /mnt/cogn \) -prune -false -o -name 'tnsnames.ora'


#FIND with EXEC function
#С помощью find найдите все обычные файлы с расширением .htm, расположенные в директории /usr/share/doc и во всех ее 
#поддиректориях. Измените расширение на .html для найденных файлов. Выполните поиск и переименование с помощью find 
#одной строкой.
find /usr/share/doc -type f -name "*.htm" -exec mv {} {}l \;
#change file extensions recursively in dir from "t1" to "t2"
find . -name "*.t1" -exec bash -c 'mv "$1" "${1%.t1}".t2' - '{}' \;
#Найти и удалить файлы старше 7 дней
find /var/log/* -mtime +7 -exec rm {} \;
#Найти и удалить файлы старше 6 месяцев
find /var/log/* -mtime +182 -exec rm {} \;
#Найти и удалить файлы ТОЛЬКО с расширением .log старше 30 дней
find /var/log -name "*.log" -type f -mtime +30 -exec rm -f {} \;
#if ERROR  Argument list too long:
# for i in /var/spool/exim/msglog/*; do find $i -mtime +100 -exec rm {} \;; done
# recursive
find . -name "*.pdf" -print0 | xargs -0 rm
# non-recursive
find . -maxdepth 1 -name "*.pdf" -print0 | xargs -0 rm


#Copy all files from ~/Downloads to ~/Downloads/apcupsd_d directory, changed in last 1 minute
find ~/Downloads/* -mmin -1 -exec cp {} ~/Downloads/apcupsd_d \;
#Найти файлы больше 1Мб, отсортировать по размеру и вывести ТОП-5
#find in current dir files with size more than 1Mb
#exec command ls with keys -hlS - -h(human reabable, uses with key -l) -S(sort by file size, largest first)
#final command- "head -5" cuts first five lines of the output
find . -size +1M -exec ls -hlS {} \+ |head -5
#FIND-EXEC with SED function
#Change word in all files in exiting directory recursively
cd /tmp/test
find . -type f -exec sed -i  "s/OLDPASSWD/NEWPASSWD/g" {} +
#Find in /etc/ and change IP-address in all files(*-asterisk if IP written with port(for example)), errors output in devnull
find /etc/ -type f -exec sed -i 's/10.8.181.95*/10.5.10.149/g' {} + 2> /dev/null

#если нужно перебрать большое кол-во файлов и при выводе команды grep -ri "10.8.37.147" /var/log выходит ошибка 
#"grep: memory exhaust" (память заполнена, это потому что grep перебирает все сразу, забивая ОЗУ) можно попробовать 
#выполнить grep в связке с командой find, перебирая каждый файл по очереди:
find /var/log -type f -exec grep -H "10.8.37.147" "{}" \;

#show inodes usage( do in "/")
#  find . – for doing the search in current directory (. can be replaced by full path)
# -printf “%h\n” – prints leading directories of file’s name.
# cut -d/ -f-2 – trimming the output with de-limiter “/”
# sort | uniq -c – sort and count
find / -printf "%h\n" | cut -d/ -f-2 | sort | uniq -c | sort -rn

#Find out current disk name
sudo fdisk -l | grep '^Disk /dev/sd[a-z]'


#if rm -rf /var/log/app/*.gz - ERROR bash: /bin/rm: Argument list too long:
find /var/log/app/ -name '*.gz' -type f -delete


#find all hard links by inode num
ls -lahi dir_1                   
total 24K
15614443 drwxrwxr-x 2 user user 4,0K ноя 18 22:03 .
15614436 drwxrwxr-x 4 user user 4,0K ноя 18 22:02 ..
15614445 -rw-rw-r-- 1 user user    2 ноя 18 22:02 file_1
15614446 -rw-rw-r-- 1 user user    2 ноя 18 22:02 file_2
15614447 -rw-rw-r-- 2 user user    2 ноя 18 22:02 file_3 # this file has two hard links ( 3rd column)
15614448 -rw-rw-r-- 1 user user    2 ноя 18 22:03 file_4
# find by known inode num
find / -inum 15614447 2>/dev/null
/home/user/test/dir_1/file_3
/home/user/test/dir_2/file_5
