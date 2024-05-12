#TOP command
# alterantives - atop, htop

#commands in running top screen
#in running top:
k #kill the process
r #renice the process
M # sort by RAM usage
T # sort by common CPU usage
P # sort by now CPU usage
u # show procecces by user
f # chose other parameters to show
? # commands statistics usage in top

#show top for current user
top -u $USER

#sort by TIME and exit
top -o TIME+ -n 1

# show only PID of first five
top -b | awk 'FNR>=7 && FNR<=12{print $1};FNR==12{exit}'

#show current user top 5 processes by CPU and exit
top -b -u $USER -o %CPU -n 1| awk 'NR>=7 && NR<=12 {print NR,$0}'

#show current user top 5 processes by MEM and exit
top -b -o %MEM -n 1| awk 'NR>=7 && NR<=12 {print NR,$0}'
7     PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
8   39045 root      20   0 1298680  64232  45368 S   0.0   3.2   0:14.05 dockerd
9   20969 root      19  -1  101200  58800  57616 S   0.0   2.9   0:17.23 systemd-journal
10   38880 root      20   0 1347552  42716  31488 S   0.0   2.1   1:29.40 containerd
11     540 root      20   0   32016  16804   8804 S   0.0   0.8   0:00.15 networkd-dispat
12     589 root      20   0  110508  16732   9100 S   0.0   0.8   0:00.14 unattended-upgr

