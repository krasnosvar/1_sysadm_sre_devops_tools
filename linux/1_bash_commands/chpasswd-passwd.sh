#change pass in one line command ( only by root)
echo "passssssword" | passwd root --stdin > /dev/null

echo root:passssssword | chpasswd
