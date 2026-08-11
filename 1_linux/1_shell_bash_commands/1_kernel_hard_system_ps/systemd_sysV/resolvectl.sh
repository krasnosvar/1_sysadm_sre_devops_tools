#resolvectl
#query/control the systemd-resolved DNS resolver

#show global + per-interface DNS status
resolvectl status

#resolve a hostname
resolvectl query example.com

#show DNS servers only
resolvectl dns

#flush the resolver cache
resolvectl flush-caches
