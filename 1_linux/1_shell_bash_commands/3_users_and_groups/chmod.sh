#chmod in symbolic type
#o - others
#a - all
#g - group
# u - file OWNER
chmod u-r file
#remove read permission from OTHERS
chmod o-r filea
#read and execute permissions are added for user, group, and others(ALL)
chmod a+rx fileb
#read, write, and execute permissions are assigned to GROUP
chmod g=rwx filec
#chmod read-write to user-group and read to others
chmod ug=rw,o=r file
#user read-write group-others no permessions
chmod u=rw,go= file12


#chmod in octal type
# 0400	Allows the owner to read
# 0200	Allows the owner to write
# 0100	Allows the owner to execute files and search in the directory
# 0040	Allows group members to read
# 0020	Allows group members to write
# 0010	Allows group members to execute files and search in the directory
# 0004	Allows everyone or the world to read
# 0002	Allows everyone or the world to write
# 0001	Allows everyone or the world to execute files and search in the directory
# 1000	Sets the sticky bit
# 2000	Sets the setgid bit
# 4000	Sets the setuid bit
# 4 = r (Read)
# 2 = w (Write)
# 1 = x (eXecute)
# To represent rwx triplet use 4+2+1=7
# To represent rw- triplet use 4+2+0=6
# To represent r– triplet use 4+0+0=4
# To represent r-x triplet use 4+0+1=5
chmod 0700 file.txt
