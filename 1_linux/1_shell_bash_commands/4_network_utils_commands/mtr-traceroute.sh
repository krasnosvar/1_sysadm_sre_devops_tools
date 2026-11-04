#MTR - traceroute + ping in one, shows loss/latency per hop
mtr 8.8.8.8
mtr -rwzc 100 example.com        # report: wide, AS numbers, 100 probes
mtr -T -P 443 example.com        # TCP probes (when ICMP is filtered)
mtr -u example.com               # UDP probes
mtr -4 / mtr -6                  # force IP version
# loss only on a middle hop but not at the end - usually ICMP rate limit, not a problem

#TRACEROUTE / TRACEPATH
traceroute -n example.com
sudo traceroute -T -p 443 -n example.com   # TCP SYN
traceroute -I example.com                  # ICMP
tracepath -n example.com                   # no root, also shows PMTU
