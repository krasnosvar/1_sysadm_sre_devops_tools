#useradd
#create system user
useradd -r tomcat --shell /bin/false
#create user 'user' with: home dir, bash shell, and same group as name 
useradd -mU user --shell /bin/bash

#add user in "hand mode"
#https://unix.stackexchange.com/questions/153225/what-steps-to-add-a-user-to-a-system-without-using-useradd-adduser
#/etc/passwd
#den:x:1000:1000::/home/den:/bin/bash
sudo vipw
sudo cp -r /etc/skel/ /home/user/ && sudo chown -R user /home/user && sudo chmod -R go=u,go-w /home/user && sudo chmod go= /home/user
sudo passwd user

#allow SUDO to user
echo "user ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/user
#Random password generation
openssl rand -base64 12
#make user sudoer
sudo useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
#or oneliner
#if user exists, but no sudo
usr=den && echo "$usr ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$usr
#CREATE new user and sudo
usr=den && sudo useradd -s /bin/bash -mU $usr && echo "$usr ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$usr

#userdel- delete user
#-r remove home dir
#-f delete files in "home" even not user permissions
userdel -r -f test_user


#GROUPS
#addgroup
sudo addgroup usergr
#add group in "hand mode"
sudo vigr

#create grooup with specific id
groupadd -g 100 users

#usermod
#assign to user specific UID
usermod -u 2005 foo
#add user to group
sudo usermod -aG docker ${USER}
sudo usermod -aG admin den
#check users in group
getent group admin
#rename user to user2 and homedir
usermod -l user2 user
sudo usermod --shell /bin/bash --home /home/user2 user2
# Change the user's home directory + Move the contents of the user's current directory:
usermod -m -d /newhome/username username

#remove user from group "usergr"
sudo gpasswd -d user usergr
