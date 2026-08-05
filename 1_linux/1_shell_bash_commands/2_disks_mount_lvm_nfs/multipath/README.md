* https://ubuntu.com/server/docs/device-mapper-multipathing-configuration
* https://sapikuda.com/linux/2021/03/21/multipath-configuration-for-huawei-oceanstor-dorado-series-storage/




#### TASK: Add Dorado LUN already physically connected to OS (Debian) and add to LVM

```
# apt install multipath-tools


# cat /etc/multipath.conf
devices {
         device {
                   vendor                  "HUAWEI"
                   product                 "XSG1"
                   path_grouping_policy    multibus
                   path_checker            tur
                   prio                    const
                   path_selector           "service-time 0"
                   failback                immediate
                   no_path_retry           15
        }
}
defaults {
        user_friendly_names yes
        find_multipaths yes
}


# systemctl reload multipathd


# multipath -ll
mpatha (36d4464910069e9f9997f987900000043) dm-1 HUAWEI,XSG1
size=7.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=1 status=active
  |- 15:0:0:1 sdb 8:16 active ready running
  |- 15:0:1:1 sdc 8:32 active ready running
  |- 17:0:0:1 sdd 8:48 active ready running
  `- 17:0:1:1 sde 8:64 active ready running


# dmsetup ls
deb--vg-root	(254:0)
mpatha	(254:1)


# ls -lahd /dev/dm*
brw-rw---- 1 root disk 254, 0 Jul  3 12:22 /dev/dm-0
brw-rw---- 1 root disk 254, 1 Jul  3 12:22 /dev/dm-1


# pvcreate /dev/dm-1
# pvs
# vgcreate vg_data /dev/dm-1
# vgs
# lvcreate -n lv_data -l 100%FREE vg_data
# lvs
# mkfs.ext4 /dev/vg_data/lv_data
# mkdir /data


blkid
vi /etc/fstab 
# cat /etc/fstab 
#/dev/mapper/vg_data-lv_data: 
UUID=f8a22449-0462-445c-b9a0-b919a6dc1907 /var                    ext4    defaults        0 2
```
