# copy from remote server with specific ssh key
rsync -vuarpP -e 'ssh -i ~/.ssh/other_key.rsa' remote_user@10.8.77.14:/home/remote_user/envoy_configs ~/home/local_user/


#Exclude a Specific File
rsync -a --exclude 'file.txt' src_directory/ dst_directory/
#Exclude a Specific Directory
rsync -a --exclude 'dir1' src_directory/ dst_directory/
#exclude the directory content but not the directory itself use dir1/* instead of dir1:
rsync -a --exclude 'dir1/*' src_directory/ dst_directory/


#Если при копировании на удаленный сервер выходит ошибка Permission denied
#Надо принудительно указать что rsync на той стороне выполняется с sudo:
rsync -a -e "ssh" --rsync-path="sudo rsync" /source/path /destination/path


=======
#Задача: скопировать с 10.8.98.62 папку /var/www/html/domain.ru/upload на 10.8.37.1
#Оба сервена напрямую недоступны, 
#Команду вида:
#rsync -vuar host1:/var/www host2:/var/www
#выполнить нельзя, тк источник копирования и сервер куда копируем не могут быть оба не локальными серверами при подключении
#The source and destination cannot both be remote.
#решение- использовать ПК админа как шлюз для rsync
#https://unix.stackexchange.com/questions/183504/how-to-rsync-files-between-two-remotes
ssh -v -R 50000:10.8.37.1:22 local@10.8.98.62
#после выполнения этой команды мы попадаем на 10.8.98.62:
[local@v00mkworker1 ~]$
#на 10.8.98.62 выполняем команду:
rsync -e "ssh -p 50000" -vuar --progress /var/www/html/domain.ru/upload user@localhost:/sql_db/upload
#Для возобновления закачки при обрыве нужно добавить ключи -P --append-verify
rsync -e "ssh -p 50000" -vuarP --append-verify --progress /var/www/html/domain.ru/upload user@localhost:/sql_db/upload


######################################################################################################
#объяснение ключей
#from ssh man
-R порт:машина:порт_машины
    Указывает заданный порт на удаленной машине (сервере) который будет перенаправлен к заданной машине и локальному порту. 
    Это реализовано путём назначения доменного подключения "прослушиваемому" порту со стороны удаленной машины и всякий раз, 
    когда производится соединение на этот порт, оно будет перенаправлено через защищенный канал и произведено соединение 
    к порту порт_машины локальной машины. Перенаправление портов может быть так же указано в файле конфигурации. 
    Только суперпользователь может осуществлять перенаправление привилегированных портов. 

#man rsync
    -e, --rsh=COMMAND
    указывает замену программу удаленной оболочки
    -v, --verbose
    увеличить уровень подробностей 
    -u, --update
    только обновление (не переписывает более новые файлы) 
    -a, --archive
    архивный режим, эквивалент для -rlptgoD 
    -r, --recursive
    рекурсивно входить в подкаталоги 
    -P
    эквивалент для --partial --progress 
        --partial
        сохранять частично переданные файлы 
        --progress
        показать % выполнения во время передачи 
    --append-verify         --append w/old data in file checksum

#Для сохранения аттрибутов применить ключи:
-l, --links
    копировать символьные ссылки как символьные ссылки 
-L, --copy-links
    копировать то, на что ссылаются символьные ссылки 
--copy-unsafe-links
    копировать ccылки за пределы исходного дерева каталогов 
--safe-links
    не копировать любые символьные ссылки, которые ссылаются за пределы дерева каталогов назначения 
-H, --hard-links
    сохранять жесткие ссылки 
-p, --perms
    сохранять разрешения 
-o, --owner
    сохранять владельца (только root) 
-g, --group
    сохранять группу 
-D, --devices
    сохранять файлы устройств (только root) 
-t, --times
    сохранять время 
################################################################################

backup_dir=/media/den/1tb_wd/backup;\
rsync -vuarPp /home/den/git_projects $backup_dir && \
rsync -vuarPp ~/.bashrc $backup_dir && \
rsync -vuarPp /etc/environment $backup_dir && \
rsync -vuarPp ~/.vimrc $backup_dir && \
rsync -vuarPp ~/.zshrc $backup_dir && \
rsync -vuarPp -r ~/.byobu $backup_dir


# set I/O limit in 1000 KBytes per second
rsync -vuarP  --bwlimit=1000 bundle_file den@10.10.10.7:/home/den


#rsync with non standart ssh port
rsync -vuarPp -e 'ssh -p 3333' den@localhost:/home/den/k0s ~/k0s_test/new_cluster
