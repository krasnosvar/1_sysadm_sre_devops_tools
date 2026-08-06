#### Monitoring and log tools

```
.
├── elasticsearch
│   └── elastic_commands.sh
└── rsyslog
    ├── log-to-radar.conf
    └── rsyslogd.sh
```

1. [elasticsearch/elastic_commands.sh](elasticsearch/elastic_commands.sh) - Elasticsearch REST API / cluster commands
2. [rsyslog](rsyslog) - rsyslog commands (`rsyslogd.sh`) and a sample log-forwarding config (`log-to-radar.conf`) that ships local `httpd`/filetransfer logs to a remote syslog collector - rename hosts/IPs before reuse
