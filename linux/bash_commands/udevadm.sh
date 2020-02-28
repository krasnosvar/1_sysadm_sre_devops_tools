#While the udev program runs in the background on your Linux system, you can still inter-
#act with it using the udevadm command-line tool. The udevadm command allows you to
#send commands to the udev program. The format of the udevadm command is as follows:

udevadm command [options]

control #Modifies the internal state of udev
info #Queries the udev database for device information
monitor #Listens for kernel events and display them
settle #Watches the udev event queue
test #Simulates a udev event
test-builtin #Runs a built-in device command for debugging
trigger #Requests device events from the kernel

#info #Queries the udev database for device information
#all All values
#-n --name=NAME Node or symlink name used for query or attribute walk
udevadm info --query=all --name /dev/sda
