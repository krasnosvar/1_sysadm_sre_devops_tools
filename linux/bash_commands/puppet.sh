#puppet modules repo 
https://forge.puppet.com

#build puppet module from local directory "puppet-ca_cert-master"
sudo puppet module build puppet-ca_cert-master

#install puppet module from local file
puppet module install puppet-ca_cert-master/pkg/pcfens-ca_cert-2.1.3.tar.gz  --ignore-dependencies --force