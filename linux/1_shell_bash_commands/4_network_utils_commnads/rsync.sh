# copy from remote server with specific ssh key
rsync -vuarpP -e 'ssh -i ~/.ssh/other_key.rsa' remote_user@10.8.77.14:/home/remote_user/envoy_configs ~/home/local_user/


#Exclude a Specific File
rsync -a --exclude 'file.txt' src_directory/ dst_directory/
#Exclude a Specific Directory
rsync -a --exclude 'dir1' src_directory/ dst_directory/
#exclude the directory content but not the directory itself use dir1/* instead of dir1:
rsync -a --exclude 'dir1/*' src_directory/ dst_directory/


#If when copying to remote server you get Permission denied error
#Need to force specify that rsync on that side runs with sudo:
rsync -a -e "ssh" --rsync-path="sudo rsync" /source/path /destination/path


=======
#Task: copy from 10.8.98.62 folder /var/www/html/domain.ru/upload to 10.8.37.1
#Both servers are not directly accessible,
#Command like:
#rsync -vuar host1:/var/www host2:/var/www
#cannot be executed, because source and destination server cannot both be non-local when connecting
#The source and destination cannot both be remote.
#solution- use admin PC as gateway for rsync
#https://unix.stackexchange.com/questions/183504/how-to-rsync-files-between-two-remotes
ssh -v -R 50000:10.8.37.1:22 local@10.8.98.62
#after executing this command we get to 10.8.98.62:
[local@v00mkworker1 ~]$
#on 10.8.98.62 execute command:
rsync -e "ssh -p 50000" -vuar --progress /var/www/html/domain.ru/upload user@localhost:/sql_db/upload
#For resuming download when interrupted need to add keys -P --append-verify
rsync -e "ssh -p 50000" -vuarP --append-verify --progress /var/www/html/domain.ru/upload user@localhost:/sql_db/upload


######################################################################################################
#explanation of keys
#from ssh man
-R port:machine:port_machine
    Specifies the given port on remote machine (server) which will be redirected to given machine and local port.
    This is implemented by assigning domain connection to "listening" port on remote machine side and every time
    when connection is made to this port, it will be redirected through secure channel and connection will be made
    to port_machine port of local machine. Port forwarding can also be specified in configuration file.
    Only superuser can perform privileged port forwarding. 

#man rsync
    -e, --rsh=COMMAND
    specifies replacement remote shell program
    -v, --verbose
    increase verbosity level
    -u, --update
    update only (doesn't overwrite newer files)
    -a, --archive
    archive mode, equivalent to -rlptgoD
    -r, --recursive
    recursively enter subdirectories
    -P
    equivalent to --partial --progress
        --partial
        preserve partially transferred files
        --progress
        show % progress during transfer 
    --append-verify         --append w/old data in file checksum

#To preserve attributes apply keys:
-l, --links
    copy symbolic links as symbolic links
-L, --copy-links
    copy what symbolic links point to
--copy-unsafe-links
    copy links outside source directory tree
--safe-links
    don't copy any symbolic links that point outside destination directory tree
-H, --hard-links
    preserve hard links
-p, --perms
    preserve permissions
-o, --owner
    preserve owner (root only)
-g, --group
    preserve group
-D, --devices
    preserve device files (root only)
-t, --times
    preserve times 
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
