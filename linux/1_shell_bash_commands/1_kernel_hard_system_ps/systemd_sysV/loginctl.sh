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


# check wayland or x11
# https://unix.stackexchange.com/questions/202891/how-to-know-whether-wayland-or-x11-is-being-used
loginctl
loginctl show-session <SESSION_ID> -p Type
# or in one command
loginctl show-session $(awk '/tty/ {print $1}' <(loginctl)) -p Type | awk -F= '{print $2}'
