# all about linux procecces 
# list commands here:
ps
pgrep
pstree
nice-renice
kill
pkill
# Processes isolation:
ulimit
taskset
cgroups


#убить процессы пользователя toor (например, для его удаления)
ps aux | awk '/^toor/ {print $2}' | xargs kill -9
pkill -u toor
---------------------------------------------------------------------------------------------

# удалили файл, открывший приложение. Как нам его восстановить?
# https://habr.com/ru/articles/208104/
# Файл лежит где лежал, пока он открыт хоть одним процессом. Как только все процессы закроют файл или завершатся, 
# место на диске помечается как свободное и может быть перезаписано другим файлом.
# 1. восстановить исполняемый файл( лежит по пути):
sudo ls -lia /proc/526/exe 
17961405 lrwxrwxrwx 1 root root 0 авг  6 00:10 /proc/526/exe -> /usr/sbin/rsyslogd
# 2. Восстанавливаем файл, который открыт процессом:
# у нас стоит приложение lsof и примонтирован procfs в /proc.
# Первым делом нам нужно найти открытый файл с помощью программы lsof:
$ sudo lsof | grep /home/anton/.xsession-errors
kwin 2031 4002 anton 2w REG 253,3 4486557 1835028 /home/anton/.xsession-errors
# Нас интересуют вот эти значения:
# Номер процесса (pid) - 2031
# Файловый дескриптор (file descriptor) - 2w
# Дальше восстанавливаем его (вы можете также его сохранить в другом месте):
sudo cp /proc/2031/fd/2 /home/anton/.xsession-error
# 3. еще в теории можно создать хардлинк на файл и счетчик не будет равен 0 и файл не удалится



#PS
#short summary of the active processes
ps aux
#shows exact command that was used to start process
ps -ef
#shows hierarchical relationships between parent and child processes
ps fax
#Displaying top CPU_consuming processes:
ps aux | head -1; ps aux | sort -rn +2 | head -10
#Displaying top 10 memory-consuming processes:
ps aux | head -1; ps aux | sort -rn +3 | head
#look top-10 processes by mem-usage
ps aux --sort=-%mem | awk 'NR<=10{print $0}'
#Displaying process in order of being penalized:
ps -eakl | head -1; ps -eakl | sort -rn +5
#Displaying process in order of priority:
ps -eakl | sort -n +6 | head
#Displaying process in order of nice value
ps -eakl | sort -n +7
#Displaying the process in order of time
ps vx | head -1;ps vx | grep -v PID | sort -rn +3 | head -10
#Displaying the process in order of real memory use
ps vx | head -1; ps vx | grep -v PID | sort -rn +6 | head -10
#Displaying the process in order of I/O
ps vx | head -1; ps vx | grep -v PID | sort -rn +4 | head -10
#Displaying WLM classes
ps -a -o pid, user, class, pcpu, pmem, args
#Determinimg process ID of wait processes:
ps vg | head -1; ps vg | grep -w wait
#Wait process bound to CPU
ps -mo THREAD -p <PID>

#не совсем ps но тоже относится к процессам
#запустить графическую программу из консоли чтобы она отпустила консоль при запуске
sudo pac  > /dev/null 2>&1 &

#Cpu usage with priority levels
topas -P

#PGREP
#pgrep looks through the currently running processes and lists the process IDs which match the selection criteria to stdout
#Use pgrep dd to get a list of all PIDs that have a name containing the string dd
pgrep tmux
#only list the processes called sshd AND owned by root
pgrep -u root sshd
#list the processes owned by root OR den
pgrep -u root,den sshd
#pstree - display a tree of processes
pstree

#NICE-RENICE
#start process with manually set niceness
nice -n 5 dd if=/dev/zero of=/dev/null &
#decrease the priority of the process to 10( to 19 max)
renice -n 10 p 1310
#increase the priority of the process to -10( to -20 max), only root can increace niceness
sudo renice -n -10 p 1310
# https://www.tecmint.com/set-linux-process-priority-using-nice-and-renice-commands/
# renice created sleep to 15
( sleep 10000 & echo $! >&3 ) 3>pid | renice -n 15 -p $(<pid)

#KILL PKILL
#Sending Signals to Processes with kill, killall, and pkill
# The signal SIGTERM (15) is used to ask a process to stop.
# The signal SIGKILL (9) is used to force a process to stop.
# The SIGHUP (1) signal is used to hang up a process.
kill "PID" #This sends the SIGTERM signal to the process, which normally causes the process to cease its activity
kill -9 #sends the SIGKILL signal to the process. SIGKILL signal cannot be ignored, it forces the process to stop, but you also risk losing data while using this command
kill -l #show a list of available signals that can be used with kill
# - типов сигналов много ( kill- передать сигнал процессу)
kill -l
 1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL	 5) SIGTRAP
 6) SIGABRT	 7) SIGBUS	 8) SIGFPE	 9) SIGKILL	10) SIGUSR1
11) SIGSEGV	12) SIGUSR2	13) SIGPIPE	14) SIGALRM	15) SIGTERM
# - Некоторые из наиболее часто используемых сигналов:
1 HUP (hang up) — повесить.
2 INT (interrupt) — прерывание.
3 QUIT (quit) — выход.
6 ABRT (abort) — прерывания.
9 KILL (non-catchable, non-ignorable kill)
14 ALRM (alarm clock) — будильник.
15 TERM (software termination signal) — Программное обеспечение для прекращения сигнала.
# - убить процесс:
ps aux| grep java
kill SIGKILL PID
kill -9 8976
# - убить процесс не по PID а по имени
pkill java
# - убить все процессы пользователя
pkill -u nobody


# How to get pid of just started process
# https://serverfault.com/questions/205498/how-to-get-pid-of-just-started-process
go run main.go & echo $!


ulimit


taskset
#move process to another CPU core
# * https://www.xmodulo.com/run-program-process-specific-cpu-cores-linux.html
# https://www.redhat.com/sysadmin/tune-linux-tips
#install in ubuntu
sudo apt install util-linux
# create sleep in backgroud, fetch pid and move to CPU0 core
( sleep 10000 & echo $! >&3 ) 3>pid && taskset -cp 0 $(<pid)


cgroups
