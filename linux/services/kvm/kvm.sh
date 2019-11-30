#Используем KVM для создания виртуальных машин на сервере
https://khashtamov.com/ru/kvm-setup-server/
#Введение в Vagrant
https://khashtamov.com/ru/vagrant-how-to-setup/
#How to use vagrant-kvm 
https://gist.github.com/yuanying/924ce2ce61b75ab818b5
#Перестаем бояться виртуализации при помощи KVM
https://eax.me/kvm/
#Official site
http://www.linux-kvm.org/page/Main_Page


#installing kvm
apt-get install qemu-kvm libvirt-bin virtinst virt-manager virt-viewer
yum groupinstall “Virtualization Host”

#Что где принято хранить:
    /var/lib/libvirt/boot/ — ISO-образы для установки гостевых систем;
    /var/lib/libvirt/images/ — образы жестких дисков гостевых систем;
    /var/log/libvirt/ — тут следует искать все логи;
    /etc/libvirt/ — каталог с файлами конфигурации;

#create vm
virt-install --connect qemu:///system \
             --virt-type kvm \
             --name testkvm \
             --ram 2048 \
             --disk /media/den/250gb/kvm/testkvm.qcow,format=qcow2,size=10 \
             --cdrom /home/den/Downloads/CentOS-8-x86_64-1905-dvd1.iso \
             --vnc \
             --os-type linux \

#variant2
sudo virt-install \
--virt-type=kvm \
--name centos8_boot \
--ram 1024 \
--vcpus=1 \
--os-variant=rhl8.0 \
--hvm \
--cdrom=/home/den/Downloads/centos8/CentOS-8-x86_64-1905-dvd1.iso \
--network network=default,model=virtio \
--graphics vnc \
--disk path=/media/den/250gb/vm-disks/centos8_boot.img,size=20,bus=virtio

#Стоит обратить внимание на параметр --os-variant, он указывает гипервизору под какую именно ОС следует адаптировать настройки.
#Список доступных вариантов ОС можно получить, выполнив команду:
osinfo-query os
#Если такой утилиты нет в вашей системе, то устанавливаем:
sudo apt-get install libosinfo-bin


#commands
#list of all VMs
#currently active Vms
virsh list
#show all VMs
virsh list --all
virsh -c qemu:///system list --all
#testkvm VM info
virsh dominfo testkvm
#Start VM "testkvm"
virsh start testkvm
#shutdown VM
virsh shutdown demo-guest1
#disk info9only on shutdown VM)
sudo qemu-img info /var/lib/libvirt/images/freebsd10.img
#shutdown, destroy, edit VM
shutdown testkvm
destroy testkvm
edit testkvm
console testkvm #connect to VM directly from the console of a KVM host
#start, reboot VM
start testkvm
reboot testkvm

#network
#see ip addr of VM
virsh domifaddr --domain cs8-kub-nod2

#включить сеть в centos8
sudo nmcli device connect ens3
#port forwarding
sudo iptables -t nat -A PREROUTING -p tcp -d 10.104.20.228 --dport 5555 -j DNAT --to-destination 192.168.122.132:22
iptables -A FORWARD -i enp3s0 -d 192.168.122.132 -p tcp --dport 22 -j ACCEPT
#KVM forward ports to guests VM with UFW on Linux
https://www.cyberciti.biz/faq/kvm-forward-ports-to-guests-vm-with-ufw-on-linux/

#libvirt
#virt-manager  -- GIU Virtual Machine Manager to manadge KVM 
#virsh -- shell interface to manadge KVM
#Get Details About the libvirtd process Status
systemctl status libvirtd -l

#Accessing Virtual Machines from a Text-Only Console
# 1. Log in to the server1 VM and make sure that you have root privileges.
# 2. Type grubby --update-kernel=ALL --args=“console=ttyS0” . Using the grubby command allows you to change the configuration of the GRUB2
# boot loader without having to go through the GRUB2 configuration files. Alternatively, you can edit the /etc/default/grub file and add the argument
# console=ttyS0 to the line that specifies the kernel arguments to be used. If you are modifying the grub.conf file, use grub2-mkconfig -o /boot/grub2/
# grub.cfg to write the changes to the boot loader main configuration file.
# 3. Restart your VM, using the reboot command. 
# 4. From the KVM host, use the virsh console server1.example.com command to connect to the VM. You’ll now get access to the VM console. 
# Press Ctrl+] to get out of the virsh console session. Notice that the name of the VM you are connecting to has to match the VM name, as you
# can see it using the virsh list command.

#вывести только имена запущенных ВМ
virsh list|tail -n+3|awk '{print $2}'
#вывести ip-адреса запущенных ВМ
for i in $(virsh list|tail -n+3|awk '{print $2}'); do virsh domifaddr $i; done