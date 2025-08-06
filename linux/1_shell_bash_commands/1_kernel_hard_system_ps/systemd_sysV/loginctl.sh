#loginctl: 
#user session management.
#lock current session
loginctl lock-session
#list open sessions
loginctl list-sessions
#Get list of logged in users:
loginctl list-users
#terminate current session, closing all applications and freeing resources
loginctl terminate-session
#Display information about current session status (or any other if id is added),
#including list of child processes and virtual console number:
loginctl session-status


# check wayland or x11
# https://unix.stackexchange.com/questions/202891/how-to-know-whether-wayland-or-x11-is-being-used
loginctl
loginctl show-session <SESSION_ID> -p Type
# or in one command
loginctl show-session $(awk '/tty/ {print $1}' <(loginctl)) -p Type | awk -F= '{print $2}'
