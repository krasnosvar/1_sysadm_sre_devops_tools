# Linux Find Out What Process Are Using Swap Space
# https://www.cyberciti.biz/faq/linux-which-process-is-using-swap/
for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | sort -k 2 -n -r | less


#check usage
swapon -s
#or
cat /proc/swaps


#clean swap
swapoff -a && swapon -a


# move SWAP to swapfile
#Identify configured swap devices and files:
cat /proc/swaps
# Turn off all swap devices and files:
swapoff -a
# Remove any matching reference found in /etc/fstab
#make swapfile
sudo fallocate -l 1G /swapfile
#or
sudo dd if=/dev/zero of=/swapfile bs=1024 count=1048576 # 2G - 2097152
# set the correct permissions type. Only the root user should be able to write and read the swap file.
sudo chmod 600 /swapfile
#Use the mkswap utility to set up the file as Linux swap area:
sudo mkswap /swapfile
# Enable the swap with the following command:
sudo swapon /swapfile
# To make the change permanent open the /etc/fstab file and append the following line:
/swapfile swap swap defaults 0 0
# To verify that the swap is active, use either the swapon or the free command as shown below:
sudo swapon --show
#or
sudo free -h
