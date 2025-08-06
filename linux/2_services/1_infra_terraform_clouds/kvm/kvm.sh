#Using KVM to create virtual machines on server
https://khashtamov.com/ru/kvm-setup-server/
#Introduction to Vagrant
https://khashtamov.com/ru/vagrant-how-to-setup/
#How to use vagrant-kvm 
https://gist.github.com/yuanying/924ce2ce61b75ab818b5
#Stop being afraid of virtualization with KVM
https://eax.me/kvm/
#Official site
http://www.linux-kvm.org/page/Main_Page


#installing kvm
apt install qemu-kvm libvirt-bin virtinst virt-manager virt-viewer
yum groupinstall “Virtualization Host”

#What is typically stored where:
    /var/lib/libvirt/boot/ — ISO images for guest system installation;
    /var/lib/libvirt/images/ — hard disk images of guest systems;
    /var/log/libvirt/ — all logs should be looked for here;
    /etc/libvirt/ — directory with configuration files;

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

#Pay attention to the --os-variant parameter, it tells the hypervisor which OS to adapt settings for.
#List of available OS variants can be obtained by running the command:
osinfo-query os
#If such utility is not in your system, then install:
sudo apt install libosinfo-bin


#commands
#list of all VMs
#currently active Vms
virsh list
#show all VMs
virsh list --all
virsh -c qemu:///system list --all
#testkvm VM info
virsh dominfo testkvm
#output only names of running VMs
virsh list|tail -n+3|awk '{print $2}'
#output IP addresses of running VMs
for i in $(virsh list|tail -n+3|awk '{print $2}'); do virsh domifaddr $i; done
#Start VM "testkvm"
virsh start testkvm
#shutdown VM
virsh shutdown demo-guest1
#shutdown all VMs
for i in $(virsh -c qemu:///system list --all|tail -n+3|awk '{print $2}'); do virsh -c qemu:///system shutdown $i; done
#disk info (only on shutdowned VM)
sudo qemu-img info /var/lib/libvirt/images/freebsd10.img
#shutdown, destroy, edit VM
shutdown testkvm
destroy testkvm
edit testkvm
console testkvm #connect to VM directly from the console of a KVM host
#start, reboot VM
start testkvm
reboot testkvm

#KVM-NETWORK
#see all nets
virsh net-list --all
#see ip addr of VM
virsh domifaddr --domain cs8-kub-nod2
#enable network in centos8
sudo nmcli device connect ens3
#port forwarding
sudo iptables -t nat -A PREROUTING -p tcp -d 10.104.20.228 --dport 5555 -j DNAT --to-destination 192.168.122.132:22
iptables -A FORWARD -i enp3s0 -d 192.168.122.132 -p tcp --dport 22 -j ACCEPT
#KVM forward ports to guests VM with UFW on Linux
https://www.cyberciti.biz/faq/kvm-forward-ports-to-guests-vm-with-ufw-on-linux/
#if no default network
#https://blog.programster.org/kvm-missing-default-network
#https://wiki.libvirt.org/page/Networking
#1. Create file
#cat /usr/share/libvirt/networks/default.xml
<network>
  <name>default</name>
  <uuid>9a05da11-e96b-47f3-8253-a3a482e445f5</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:0a:cd:21'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
#2. 
virsh net-define /usr/share/libvirt/networks/default.xml
virsh net-autostart default
virsh net-start default


#KVM-DISKS
#How to add disk image to KVM virtual machine with virsh command
#Step 1 – Create the new disk image
cd /var/lib/libvirt/images/
#raw disk format
sudo qemu-img create -f raw ubuntu-box1-vm-disk1-5G 5G
#qcow disk format
# Raw disk image format is default. 
# This format has the advantage of being simple and easily exportable to all other emulators. 
# However, QEMU image format (qcow2) the most versatile format. If you need to take VM snapshots or AES encryption.
sudo qemu-img create -f qcow2 ubuntu-box2-vm-disk1-5G 5G
#or dd method(raw disk format)
sudo dd if=/dev/zero of=ubuntu-box1-vm-disk1-5G bs=1M count=5120 status=progress
#Step 2 – Attach the disk to the virtual machine
#Before you attache the disk to your VM, find out current disk name
sudo fdisk -l | grep '^Disk /dev/sd[a-z]'
#on kvm-host
virsh attach-disk {vm-name} /var/lib/libvirt/images/{img-name-here} vdb --cache none
#or
virsh attach-disk {vm-name} \
--source /var/lib/libvirt/images/{img-name-here} \
--target vdb \
--persistent
#example
#Now add a partition and format to file-system(or add to PV LVM)
sudo virsh attach-disk ubuntu-box1 /var/lib/libvirt/images/ubuntu-box1-vm-disk1-5G vdb --cache none
#resize image disk to 10G
qemu-img resize images/focal-server-cloudimg-amd64-disk-kvm.img 10G

#resize existing VM disk
# https://computingforgeeks.com/how-to-extend-increase-kvm-virtual-machine-disk-size/
sudo virsh -c qemu:///system domblklist dev1-u2004_111               
sudo file /var/lib/libvirt/images/os_image.dev1-u2004_111          
sudo qemu-img info /var/lib/libvirt/images/os_image.dev1-u2004_111
sudo qemu-img resize /var/lib/libvirt/images/os_image.dev1-u2004_111 +10G



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


#copy VM
sudo rsync -vuarP  /etc/libvirt/qemu/RDPWindows.xml /media/den/110G_ntfs/images/
sudo rsync -vuarP  /var/lib/libvirt/images/RDPWindows.qcow2 /media/den/110G_ntfs/images/

#discover all IPs with Vm-hostnames
for i in $(for i in $(virsh list|tail -n+3|awk '{print $2}'); do virsh domifaddr $i|grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'; done); do ssh den@$i 'hostname'; echo $i;  done



#ERRORS
# when creates with terraform and libvirt-plugin - access denied
echo 'security_driver = "none"' >> /etc/libvirt/qemu.conf
sudo systemctl restart libvirtd
