# dd
# https://www.cyberciti.biz/faq/howto-linux-unix-test-disk-performance-with-dd-command/
# if=/dev/zero (if=/dev/input.file) : The name of the input file you want dd the read from.
# of=/tmp/test1.img (of=/path/to/output.file) : The name of the output file you want dd write the input.file to.
# bs=1G (bs=block-size) : Set the size of the block you want dd to use. 1 gigabyte was written for the test. Please note that Linux will need 1GB of free space in RAM. If your test system does not have sufficient RAM available, use a smaller parameter for bs (such as 128MB or 64MB and so on).
# count=1 (count=number-of-blocks): The number of blocks you want dd to read.
# oflag=dsync (oflag=dsync) : Use synchronized I/O for data. Do not skip this option. This option get rid of caching and gives you good and accurate results
# conv=fdatasyn: Again, this tells dd to require a complete “sync” once, right before it exits. This option is equivalent to oflag=dsync.
dd if=/dev/zero of=/tmp/test1.img bs=256M count=1 oflag=dsync
 1+0 records in
 1+0 records out
 268435456 bytes (268 MB, 256 MiB) copied, 0.390247 s, 688 MB/s
# Testing Sequential Write Speed
dd if=/dev/zero of=/tmp/tempfile bs=1M count=1024 conv=fdatasync

#  Testing Sequential Read Speed
sudo sh -c "/usr/bin/echo 3 > /proc/sys/vm/drop_caches"

dd if=/tmp/tempfile of=/dev/null bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.295733 s, 3.6 GB/s


# iozone
# sudo apt-get install -y iozone3
# To run random read-and-write tests, we can pass the -i2 option flag to the iozone command:
# In addition to the -i2 option flag, we also configured the tests using different option flags. 
# Firstly, the -t1 option set the number of threads for test execution to one. 
# Then, we specify the -i0 to make iozone create the test file for a test. 
# Furthermore, the -r1k and -s1g configure the test to use a block size of 1 kilobyte with a total size of 1 gigabyte. 
# Finally, we set the test path to /tmp.
iozone -t1 -i0 -i2 -r1k -s1g /tmp


# fio
sudo apt-get install fio
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test \
--filename=random_read_write.fio --bs=4k --iodepth=64 --size=1G --readwrite=randrw --rwmixread=75


# hhdparm
sudo apt-get install hdparm
sudo hdparm -Tt /dev/sda
