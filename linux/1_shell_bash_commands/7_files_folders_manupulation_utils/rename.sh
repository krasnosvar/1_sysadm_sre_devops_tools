#rename extension of all files
yum -y install rename
rename 's/\.txt$/.text/' *.txt
