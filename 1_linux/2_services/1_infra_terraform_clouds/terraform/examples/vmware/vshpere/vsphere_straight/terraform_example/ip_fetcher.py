import os

vm_count = 3
ip_list = []
answer = "1 packets received"


with open('ip_list.txt') as file:
    # iterate ip adresses
    for ip_addr in file:
        # print ip for debug
        # print(ip_addr.strip())
        # pimg cmd
        response = os.popen(f"ping -c 1 {ip_addr}").read()
        if answer not in response:
            # strip newline
            ip_addr = ip_addr.strip()
            ip_list.append(ip_addr)
            print(f"{ip_addr} FREE")
            if len(ip_list) == vm_count:
                break
print(ip_list)

ip_count = -1
for i in ip_list:
    ip_count += 1
    cloudinit_config_text = f"""
    #cloud-config
    write_files:
    - path: /etc/netplan/50-cloud-init.yaml
      content: |
        network:
         version: 2
         ethernets:
          ens192:
           addresses: [{i}/24]
           gateway4: 10.0.0.1
           dhcp6: false
           nameservers:
             addresses: [10.0.0.11, 10.0.0.22]
             search:
               - domain.local
           dhcp4: false
           optional: true
    - path: /etc/sysctl.d/60-disable-ipv6.conf
      owner: root
      content: |
        net.ipv6.conf.all.disable_ipv6=1
        net.ipv6.conf.default.disable_ipv6=1
    chpasswd:
      expire: false
    system_info:
      default_user:
        name: ubuntu
        plain_text_passwd: 'ubuntu'
        lock_passwd: false
        sudo: ["ALL=(ALL) NOPASSWD:ALL"]
        groups: sudo, users, admin
    ssh_pwauth: true
    disable_root: false
    # written to /var/log/cloud-init-output.log
    final_message: "The system is finall up, after $UPTIME seconds"
    power_state:
      delay: now
      mode: reboot
      message: Rebooting the OS
    """
    try:
        with open(f'cloudinit_configs/kickstart-python{ip_count}.yaml', 'w') as f:
            f.write(cloudinit_config_text)
    except FileNotFoundError:
        print("The 'cloudinit_configs' directory does not exist")
