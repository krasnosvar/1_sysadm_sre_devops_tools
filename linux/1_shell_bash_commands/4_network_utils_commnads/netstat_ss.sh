#$$
# https://www.tecmint.com/ss-command-examples-in-linux/
# show connections on port 443
ss -at '( dport = :443 or sport = :443 )'
# show hosts, connected to 443
ss -at '( sport = :443 )'