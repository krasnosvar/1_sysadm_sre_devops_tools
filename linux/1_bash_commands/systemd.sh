#Как создать свою службу (unit) в systemd на CentOS 7
https://wiki.it-kb.ru/unix-linux/systemd/how-to-create-warmup-command-for-apache-httpd-via-custom-service-unit-in-systemd
---------------------------------------------------------------------------------------------

#systemctl
#To show all installed unit files use 
systemctl list-unit-files
#узнать, какие сервисы запущены в данный момент.
systemctl list-units -t service
systemctl --type=service
service --status-all
#
#Как мне сделать так, чтобы сервис не запускался автоматически(примерб сервис cups.service)? 
sudo systemctl disable cups
#вернуть в автозагрузку
sudo systemctl enable cups
#проверить, какие сервисы были остановлены в аварийном режиме
systemctl list-units -t service --failed
systemctl --failed --type=service
#find out which dependencies unit(sshd) has
systemctl list-dependencies sshd
#список всех типов юнитов systemd
[root@test-kvm ~]# systemctl -t help
Available unit types:
service
socket
busname
target
snapshot
device
mount
automount
swap
timer
path
slice
scope
---------------------------------------------------------------------------------------------
#SYSTEMD TARGETS
Previous versions of Red Hat Enterprise Linux, which were distributed with SysV init or Upstart,
implemented a predefined set of runlevels that represented specific modes of operation. These
runlevels were numbered from 0 to 6 and were defined by a selection of system services to be run when
a particular runlevel was enabled by the system administrator. Starting with Red Hat Enterprise Linux 7,
the concept of runlevels has been replaced with systemd targets.
#Comparison of SysV runlevels with systemd targets
0 (Runlevel 0)Shut down and power off the system. 
runlevel0.target, poweroff.target 
1  Set up a rescue shell.
runlevel1.target, rescue.target
2 Set up a non-graphical multi-user system.
runlevel2.target ,multi-user.target
3 Set up a non-graphical multi-user system.
runlevel3.target , multi-user.target 
4 Set up a non-graphical multi-usersystem.
runlevel4.target , multi-user.target 
5 Set up a graphical multi-user system.
runlevel5.target, graphical.target 
6 Shut down and reboot the system.
runlevel6.target ,reboot.target 

#Lists currently loaded target units.(old command - "runlevel")
systemctl list-units --type target
#determine which target unit is used by default
systemctl het-default
#enter rescue mode in the current session
systemctl rescue
systemctl isolate rescue.target
#change the current target and enter emergency mode
systemctl emergency
systemctl isolate emergency.target

#power management commands with systemctl
systemctl halt
systemctl poweroff
systemctl reboot
systemctl suspend




---------------------------------------------------------------------------------------------
#journalctl
#Выберем только те записи, которые касаются ошибок:
journalctl -p err
#Чтобы видеть, что попадает в логи в данный момент, воспользуйтесь командой:
journalctl -f
#Включаем постоянное логирование.
#По умолчанию Ubuntu хранит системный журнал до перезагрузки или выключения. 
#Для большинства пользователей этого достаточно, но если вы хотите хранить логи постоянно, изменить настройки будет несложно.
#Если вы хотите ограничить пространство, выделенное для хранения логов, 
#раскомментируйте (уберите «#» ) строку SystemMaxUse в файле /etc/systemd/journald.conf и установите свое значение после знака «=»(например 500M).
sudo mkdir /var/log/journal
sudo systemd-tmpfiles --create --prefix /var/log/journal
sudo systemctl restart systemd-journald
#Из постоянно хранимых логов можно выбрать записи, начиная с определенной даты:
journalctl --since=2016-12-20
journalctl --since=2016-12-20 --until=2016-12-21
journalctl -b
journalctl --since 9:00 --until 9:30

#Показать последние 20 строк логов 
journalctl -n 20

#Ищем причину медленной загрузки.
#Для анализа скорости загрузки системы в systemd включена утилита systemd-analyze. 
#Просто вызвав её из терминала, узнаем, сколько времени заняла последняя загрузка:
systemd-analyze
#детализированный отчет:
systemd-analyze blame
#отдельно логи по networking.service:
journalctl -b -u networking.service
---------------------------------------------------------------------------------------------

#localectl 
#централизованное управление языковыми и региональными параметрами.

#вывести текущие настройки
localectl
localectl status

#объяснение вывода:
System Locale — текущая системная локаль, т. е. набор правил, определяющих язык системы, формат денежных единиц, часовой пояс и т. д.
VC Keymap — раскладка клавиатуры для консоли.
X11 Layout — раскладки клавиатуры, используемые в графической системе.
X11 Model — тип/модель клавиатуры
X11 Variant — варианты раскладки клавиатуры, используемые в графической системе. Примеры: русская машинописная, DVORAK, QUERTY и т. д.
X11 Options — опции, в том числе горячие клавиши для переключения раскладки и отображение текущего состояния с помощью индикатора Scroll Lock.

#Вывести список доступных локалей:
localectl list-locales
#Изменить язык системы на английский:
localectl set-locale LANG="en_EN.utf8"
#Вывести список доступных раскладок клавиатуры:
localectl list-x11-keymap-layouts
---------------------------------------------------------------------------------------------

#timedatectl: 
#управление настройками времени и даты.

timedatectl

#объяснение вывода:
Local time — местное время.
Universal time — UTC или всемирное координированное время. Отправная точка для отсчета часовых поясов.
RTC time — время в аппаратных часах ПК или сервера.
Time Zone — часовой пояс.
Network time on — показывает, включен ли ntp-клиент, входящий в состав systemd. Даже если он отключен, синхронизация может выполняться сторонними клиентами.
NTP synchronized — показывает, синхронизировано ли время с ntp-сервером.
RTC in local TZ — показывает, какое время хранится в аппаратных часах: локальное или всемирное. Таким образом, yes означает локальное время, no — всемирное.
#Установить дату и время (работает только при выключенной синхронизации):
timedatectl set-time "2016-02-11 20:15:01"
#Отключить синхронизацию с ntp-сервером:
#В этой и других подобных командах из набора systemd в качестве булевых значений можно использовать 1\0, on\off, true\false.
timedatectl set-ntp 0
#Отобразить список часовых поясов и установить подходящий:
timedatectl list-timezones  
timedatectl set-timezone Europe/Vienna
---------------------------------------------------------------------------------------------

#loginctl: 
#управление сеансами пользователей.
#заблокировать текущую сессию
loginctl lock-session
#вывести список открытых сеансов
loginctl list-sessions
#Получить список залогинившихся пользователей:
loginctl list-users
#уничтожить текущий сеанс, закрыв все приложения и освободив ресурсы
loginctl terminate-session
#Вывести информацию о состоянии текущего сеанса (или любого другого, если добавить id), 
#включая список дочерних процессов и номер виртуальной консоли:
loginctl session-status
---------------------------------------------------------------------------------------------


HOSTNAMECTL
#change hostname
hostnamectl set-hostname v00opshift04tst
