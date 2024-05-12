terraform {
 required_version = ">= 1"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.6.3"
    }
  }
}

# variables that can be overriden
variable "hostname" {
  type    = list(string)
  # default = ["dev1-centos8", "dev2-centos8"]
  default = ["dev1-u2004_111"]
}
#variable "hostname" { default = "vm_u20" }
variable "domain" { default = "local" }
variable "memoryMB" { default = 1024*4 }
variable "cpu" { default = 4 }

# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
}

# fetch the latest ubuntu release image from their mirrors.
#when ising cloud image- now allowed to increase disk-size
#only on localy downloaded image with command:
#qemu-img resize images/focal-server-cloudimg-amd64-disk-kvm.img 10G
resource "libvirt_volume" "os_image" {
  count = length(var.hostname)
  name = "os_image.${var.hostname[count.index]}"
  pool = "default"
  #Cloud official images
  #source = "https://cloud-images.ubuntu.com/focal/20210720/focal-server-cloudimg-amd64-disk-kvm.img"
  #source = "https://cloud-images.ubuntu.com/focal/20210720/focal-server-cloudimg-amd64.img"
  #source = "https://cloud-images.ubuntu.com/focal/20210720/focal-server-cloudimg-arm64.img"
  #source = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2009.qcow2"
  #source = "https://cloud.centos.org/centos/7/images/CentOS-7-aarch64-GenericCloud-2009.qcow2"
  #source = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"
  #source = "https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20210603.0.x86_64.qcow2"
  #source = "https://cloud.centos.org/centos/8/aarch64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.aarch64.qcow2"
  #source = "https://cloud.centos.org/centos/8-stream/aarch64/images/CentOS-Stream-GenericCloud-8-20210603.0.aarch64.qcow2"
  #local cloud-init images
  #source = "/media/den/1tb_wd/images/cloud_images/focal/20210720/focal-server-cloudimg-amd64-disk-kvm.img"
  source = "/media/den/1Tb_wd/images/cloud_images/ubuntu/focal/20211026/focal-server-cloudimg-amd64.img"
  #source = "/media/den/1tb_wd/images/cloud_images/focal/20210720/focal-server-cloudimg-arm64.img"
  #source = "/media/den/1tb_wd/images/cloud_images/CentOS-7-x86_64-GenericCloud-2009.qcow2"
  #source = "/media/den/1tb_wd/images/cloud_images/CentOS-7-aarch64-GenericCloud-2009.qcow2"
  #source = "/media/den/1tb_wd/images/cloud_images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"
  #source = "/media/den/1tb_wd/images/cloud_images/CentOS-Stream-GenericCloud-8-20210603.0.x86_64.qcow2"
  #source = "/media/den/1tb_wd/images/cloud_images/CentOS-8-GenericCloud-8.4.2105-20210603.0.aarch64.qcow2"
  #source = "/media/den/1tb_wd/images/cloud_images/CentOS-Stream-GenericCloud-8-20210603.0.aarch64.qcow2"
  # source = "/media/den/1tb_wd/images/cloud_images/CentOS-7-x86_64-GenericCloud-2009-20G.qcow2"
  format = "qcow2"
}

# Use CloudInit ISO to add ssh-key and config to the instance
resource "libvirt_cloudinit_disk" "commoninit" {
          count = length(var.hostname)
          name = "${var.hostname[count.index]}-commoninit.iso"
          user_data = templatefile("${path.module}/cloud_init_configs/cloud_init_ubuntu20.cfg", 
                                   { hostname = element(var.hostname, count.index), fqdn = "${var.hostname[count.index]}.${var.domain}" })
          network_config = file("${path.module}/network_config_dhcp.cfg")
}

# Create the machine
resource "libvirt_domain" "domain-centos7" {
  count = length(var.hostname)
  name = "${var.hostname[count.index]}"
  memory = var.memoryMB
  vcpu = var.cpu
  disk {
       volume_id = element(libvirt_volume.os_image.*.id, count.index)
  }

  network_interface {
      network_name = "default"
      wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  # IMPORTANT
  # Ubuntu can hang is a isa-serial is not present at boot time.
  # If you find your CPU 100% and never is available this is why
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = "true"
  }
}

terraform { 
  required_version = ">= 0.12"
}

output "ips" {
  # show IP, run 'terraform refresh' if not populated
  value = libvirt_domain.domain-centos7.*.network_interface.0.addresses
}
