-f ––force Overwrite any preexisting destination files with same name
as DEST .
-i ––interactive Ask before overwriting any preexisting destination files with the
same name as DEST .
-n ––no-clobber Do not overwrite any preexisting destination files with the same
name as DEST .
-u ––update Only overwrite preexisting destination files with the same name
as DEST if the source file is newer.
-v ––verbose Provide detaile


#mv from /home/builder to /home/test_b
[root@localhost ~]# mv /home/builder/ /home/test_b
[root@localhost ~]# ll /home/builder/
ls: cannot access '/home/builder/': No such file or directory
[root@localhost ~]# ll /home/test_b
total 0
drwxr-xr-x. 8 builder builder 89 May 26 13:50 rpmbuild
drwxrwxr-x. 3 builder builder 22 May 26 13:49 rpmbuild_ex4
