#PERFORMANCE DIAGNOSTICS: vmstat, iostat, pidstat, sar, iotop, strace, perf, bpf
# packages: sysstat (iostat/pidstat/sar), iotop, strace, perf, bpftrace, bcc-tools

#VMSTAT - cpu/mem/swap/io overview every 1s, 5 times
# r - run queue, b - blocked on IO, si/so - swap in/out, wa - IO wait, st - steal
vmstat 1 5
vmstat -w -S M 1

#IOSTAT - per-disk utilization and latency
# %util ~100 and high r_await/w_await (ms) - disk is the bottleneck
iostat -xz 1
iostat -xz -p nvme0n1 1

#PIDSTAT - per-process cpu / disk / memory / context switches
pidstat 1
pidstat -d 1          # disk IO per process
pidstat -r 1          # memory, page faults
pidstat -w -p PID 1   # voluntary/involuntary context switches

#SAR - history (enable collector: systemctl enable --now sysstat)
sar -u 1 5                       # cpu now
sar -r                           # memory today
sar -n DEV 1                     # network per interface
sar -f /var/log/sa/sa$(date +%d) -u -s 10:00:00 -e 11:00:00   # from history

#IOTOP - who is doing disk IO right now
sudo iotop -oPa

#STRACE - syscalls of a process
strace -f -tt -T -o /tmp/strace.log CMD args   # run command under strace
sudo strace -f -p PID                          # attach to running process
sudo strace -c -f -p PID                       # summary: syscall counts/time
strace -e trace=openat,connect -f CMD          # only selected syscalls
strace -e trace=network -f -p PID

#PERF - cpu profiling
sudo perf top                                  # live top functions
sudo perf stat -p PID -- sleep 10              # counters: cycles, IPC, misses
sudo perf record -F 99 -g -p PID -- sleep 30   # sample with call graphs
sudo perf report --stdio

#BPF (bcc-tools: /usr/share/bcc/tools on Fedora, *-bpfcc on Ubuntu)
sudo execsnoop          # every new process
sudo opensnoop -p PID   # files opened
sudo biolatency 1 5     # block IO latency histogram
sudo tcpconnect         # outgoing TCP connections
sudo runqlat 1 5        # scheduler run queue latency

#BPFTRACE one-liners
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_openat { printf("%s %s\n", comm, str(args->filename)); }'
sudo bpftrace -e 'profile:hz:99 { @[comm] = count(); }'
