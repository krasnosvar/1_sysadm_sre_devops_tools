#journalctl

#sys cmds
#check journal disk usage
journalctl --disk-usage

#current boot logs
journalctl -b

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
journalctl --since "1 hour ago"
journalctl --since "2 days ago"

journalctl --since=2016-12-20
journalctl --since=2016-12-20 --until=2016-12-21
journalctl --since 9:00 --until 9:30

#Показать последние 20 строк логов 
journalctl -n 20

#Ищем причину медленной загрузки.
#Для анализа скорости загрузки системы в systemd включена утилита systemd-analyze. 
#Просто вызвав её из терминала, узнаем, сколько времени заняла последняя загрузка:
systemd-analyze
#детализированный отчет:
systemd-analyze blame

#by unit
journalctl -u nginx.service
journalctl -u nginx.service -u mysql.service
journalctl -u apache2.service -r -o json-pretty
#отдельно логи по networking.service:
journalctl -b -u networking.service
