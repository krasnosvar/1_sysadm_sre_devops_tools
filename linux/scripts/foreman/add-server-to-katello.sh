#!/bin/bash
#Check OS version
if cat /etc/*release*|grep -i "centos-7";
then
#subscribe if centos7
op_sys="Cent OS7"
#if centos6
elif cat /etc/*release*|grep -i "centos release 6";
then
op_sys="Cent OS6"
#if Oracle Linux 7
elif cat /etc/os-release | grep -E "Oracle.*Linux.*7";
then
op_sys=OL7
yum remove rhn* -y && rm -rf /etc/yum.repos.d/* && yum clean all -y
wget -O /etc/yum.repos.d/centos7osx86_64.repo http://repomirror.corp.domain.ru:10080/docs/repo/centos7osx86_64.repo 
#if Scientific Linux release 6
elif cat /etc/*release* | grep  "Scientific Linux release 6";
then
op_sys=SL6
#if RHEL-6 
elif cat /etc/*release* | grep -E "Red.*Hat.*Enterprise.*Linux.*release 6.";
then
op_sys="RedHat 6"
#if RHEL-7
elif cat /etc/*release* | grep -E "Red.*Hat.*Enterprise.*Linux.*release 7.";
then
op_sys="RedHat 7"
yum remove rhn* -y && rm -rf /etc/yum.repos.d/* && yum clean all -y
wget -O /etc/yum.repos.d/centos7osx86_64.repo http://repomirror.corp.domain.ru:10080/docs/repo/centos7osx86_64.repo
#message if none of the above systems
else
op_sys=sudo awk 'NR==1{print $1}' /etc/*release*
echo "no CentOS 6, no Centos7, no Oracle Linux 6-7 no Scientific Linux 6, no RedHat 6-7 found, aborting.";
exit
fi
#set FDQN hostname
if cat /etc/hostname | grep -v corp.domain.ru; 
then
echo $(hostname)| sed s/$(hostname)/$(hostname).corp.domain.ru/ > /etc/hostname
else
:
fi
hostname -F /etc/hostname
#Installing subscription-manager and proper OS subscription 
yum install subscription-manager -y
rpm -ivh http://v00sccmgk01nod.corp.domain.ru/pub/katello-ca-consumer-v00sccmgk01nod.corp.domain.ru-1.0-3.noarch.rpm
#rpm -ivh v00sccmgk01nod.corp.domain.ru/pub/katello-ca-consumer-latest.noarch.rpm
subscription-manager register --org="domain" --activationkey="$op_sys"
#install agents
yum install katello-agent puppet-agent -y
echo -e "[agent]\nserver = v00sccmgk01nod.corp.domain.ru" >> /etc/puppetlabs/puppet/puppet.conf
/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
#ok message
echo "##############################"
echo "ALL IS OK, HOST IN KATELLO NOW"
echo "##############################"
