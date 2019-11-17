#20 Потрясающих Примеров Команды Nmap
#https://www.shellhacks.com/ru/20-nmap-examples/
#https://www.digitalocean.com/community/tutorials/how-to-use-nmap-to-scan-for-open-ports-on-your-vps

#Scan for the host operating system:
sudo nmap -O remote_host

#scan ports 1-1024 of host
nmap rundeck

#Skip network discovery portion and assume the host is online
sudo nmap -PN remote_host

#Specify a range with “-” or “/24” to scan a number of hosts at once:
sudo nmap -PN xxx.xxx.xxx.xxx-yyy

#Scan a network range for available services:
sudo nmap -sP network_address_range

#scan all information about host
nmap -A localhost

# Стандартный ICMP пинг
nmap -sn 192.168.1.0/24

#Scan ports 1-65535
nmap -sV 192.168.1.1 -p 1-65535

#scan all information about host
nmap -A localhost

Starting Nmap 7.60 ( https://nmap.org ) at 2019-09-09 16:38 MSK
Stats: 0:00:07 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 25.00% done; ETC: 16:39 (0:00:18 remaining)
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00013s latency).
Not shown: 996 closed ports
PORT    STATE SERVICE     VERSION
22/tcp  open  ssh         OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   2048 20:b2:d4:16:2b:5e:1a:86:70:52:ed:ba:41:91:e8:78 (RSA)
|   256 f0:71:c5:b1:f0:db:8f:f8:20:66:76:5f:7e:fa:25:68 (ECDSA)
|_  256 f8:14:30:95:1c:e1:1a:7e:71:8d:1b:f2:43:d4:f3:22 (EdDSA)
139/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp open  netbios-ssn Samba smbd 4.7.6-Ubuntu (workgroup: WORKGROUP)
631/tcp open  ipp         CUPS 2.2
| http-methods:
|_  Potentially risky methods: PUT
| http-robots.txt: 1 disallowed entry
|_/
|_http-server-header: CUPS/2.2 IPP/2.1
|_http-title: Home - CUPS 2.2.7
Service Info: Host: IT-KRASNOSVAROV; OS: Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
|_nbstat: NetBIOS name: IT-KRASNOSVAROV, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| smb-os-discovery:
|   OS: Windows 6.1 (Samba 4.7.6-Ubuntu)
|   Computer name: it-krasnosvarov
|   NetBIOS computer name: IT-KRASNOSVAROV\x00
|   Domain name: corp.domain.ru
|   FQDN: it-krasnosvarov.corp.domain.ru
|_  System time: 2019-09-09T16:38:49+03:00
| smb-security-mode:
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode:
|   2.02:
|_    Message signing enabled but not required
| smb2-time:
|   date: 2019-09-09 16:38:49
|_  start_date: 1601-01-01 02:30:17

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 13.50 seconds