#digitalocean sample
https://github.com/terraform-providers/terraform-provider-digitalocean/blob/1a5c46a1acb81c951a734c4f440911cbab5f5876/examples/droplet/main.tf

#How To Use Terraform with DigitalOcean
https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean

#New Size Slugs for Droplet Plan Changes
https://developers.digitalocean.com/documentation/changelog/api-v2/new-size-slugs-for-droplet-plan-changes/

#Digitalocean API reference
https://developers.digitalocean.com/documentation/v2/#ssh-keys

#commands
terraform destroy -var-file="keys/do_token.tfvars"
terraform apply -var-file="keys/do_token.tfvars"
 

#install( with compiling to binary) new provider "libvirt"
#golang, terraform, are already installed
#KVM already installed too, but we need libvirt-dev(and update others)
sudo apt-get install -y qemu-kvm libvirt-bin libvirt-dev
#create $GOPATH
export GOPATH=/home/den/go/
#make dir, clone sources and compile binary
mkdir -p $GOPATH/src/github.com/dmacvicar; cd $GOPATH/src/github.com/dmacvicar
git clone https://github.com/dmacvicar/terraform-provider-libvirt.git
cd terraform-provider-libvirt/
go build -o terraform-provider-libvirt
#copy bin-file to terraform plugins directory
cp terraform-provider-libvirt ~/.terraform.d/plugins

#libvirt URLs
#How To Provision VMs on KVM with Terraform
https://computingforgeeks.com/how-to-provision-vms-on-kvm-with-terraform/
#How to use Terraform to create a small-scale Cloud Infrastructure
https://medium.com/terraform-how-to-create-a-smale-scale-cloud/instructions-on-how-to-use-terraform-to-create-a-small-scale-cloud-infrastructure-8c14cb8603a3#ab32
#[KVM: Terraform and cloud-init to create local KVM resources
https://fabianlee.org/2020/02/22/kvm-terraform-and-cloud-init-to-create-local-kvm-resources/
#terraform-libvirt provider for Ubuntu hosts
https://github.com/fabianlee/terraform-libvirt-ubuntu-examples


#ERRORS
#https://github.com/dmacvicar/terraform-provider-libvirt/issues/546
On Ubuntu distros SELinux is enforced by qemu even if it is disabled globally, 
this might cause unexpected Could not open '/var/lib/libvirt/images/<FILE_NAME>': 
Permission denied errors. Double check that security_driver = "none" 
is uncommented in /etc/libvirt/qemu.conf and issue sudo systemctl restart libvirt-bin to restart the daemon.

