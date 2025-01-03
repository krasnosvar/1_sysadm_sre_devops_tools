###### User permissions
* https://www.redhat.com/en/blog/suid-sgid-sticky-bit

1. User permissions explanation
```
Start at 0
If the read permission should be set, add 4
If the write permission should be set, add 2
If the execute permission should be set, add 1

This is calculated on a per access level basis. Let's interpret this permissions example:
-rw-r-x---
The permissions are represented as 650. How did I arrive at those numbers?
The user's permissions are: rw- or 4+2=6
The group's permissions are: r-x or 4+1=5
The others's permissions are: --- or 0
```


2. Special permissions:
```
Start at 0
SUID = 4
SGID = 2
Sticky = 1

SUID
user + s (pecial)
-rwsr-xr-x.
A file with SUID always executes as the user who owns the file, regardless of the user passing the command. 
If the file owner doesn't have execute permissions, then use an uppercase S here.

GUID
group + s (pecial)
drwxrws---.
This permission set is noted by a lowercase s where the x would normally indicate execute privileges for the group. 
It is also especially useful for directories that are often used in collaborative efforts between members of a group. 
Any member of the group can access any new file. This applies to the execution of files, as well. 
SGID is very powerful when utilized properly.
As noted previously for SUID, if the owning group does not have execute permissions, then an uppercase S is used.

sticky bit
other + t (sticky)
drwxrwxrwt.
"sticky bit." This permission does not affect individual files. However, at the directory level, it restricts file deletion. 
Only the owner (and root) of a file can remove the file within that directory. 
The permission set is noted by the lowercase t, where the x would normally indicate the execute privilege.
```


* Example
```
# ls -lahi user_file.txt              
52068571 -rw-rw-r-- 1 root root 0 Dec 23 12:43 user_file.txt

# chmod 2644 user_file.txt
52068571 -rw-r-Sr-- 1 root root 0 Dec 23 12:43 user_file.txt

where 2644:
2 - special SGID (uppercase S - owner has NO rights to execute)
6 - ( 4r ead + 2 write) owner has rw rights
4 - group only read
4 - others only read

# check with getfacl
getfacl user_file.txt
# file: user_file.txt
# owner: root
# group: root
# flags: -s-
user::rw-
group::r--
other::r--
```
