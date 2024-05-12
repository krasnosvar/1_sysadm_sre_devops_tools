# https://github.com/dmacvicar/terraform-provider-libvirt/blob/main/examples/v0.13/ubuntu/ubuntu-example.tf

terraform {
 required_version = ">= 1.5.2"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.7.1"
    }
    # see https://registry.terraform.io/providers/hashicorp/template
    template = {
      source = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }
}


variable "vm_condition_poweron" {
  default = true
}


# variables that can be overriden
variable "k8s-master-hostnam" {
  type    = list(string)
  default = ["m1"]
  # default = ["m1","m2","m3"]
}

variable "k8s-worker-hostn" {
  type    = list(string)
  default = ["w1","w2"]
  # default = [ "trst-srv" ]
}

# different paths to master-worker images
  variable "k8s-master-image-path" { 
    default = "/media/den/1Tb_wd/images/cloud_images/ubuntu/focal/20211026/focal-server-cloudimg-amd64.img"
  }
  variable "k8s-worker-image-path" {
    default = "/media/den/1Tb_wd/images/cloud_images/ubuntu/focal/20211026/focal-server-cloudimg-amd64-40Gdisk.img"
  }


variable "domain" { default = "local" }
variable "ramMB" { default = 1024*2 }
variable "cpu" { default = 2 }


locals {
  vm_common_list_count = concat(var.k8s-master-hostnam, var.k8s-worker-hostn)
  # creates list with condition
  # if hostname contains "m" - use default VAR for masters, otherwise modify VAR( or use another var- for images) for workers
  image_path           = [for name in local.vm_common_list_count: (strcontains(name, "m") ? var.k8s-master-image-path : var.k8s-worker-image-path)]
  mem_local_var        = [for name in local.vm_common_list_count: (strcontains(name, "m") ? var.ramMB : var.ramMB * 8)]
  cpu_local_var        = [for name in local.vm_common_list_count: (strcontains(name, "m") ? var.cpu : var.cpu * 2)]
}

# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
}

# fetch the latest ubuntu release image from their mirrors.
#when using cloud image- now allowed to increase disk-size
#only on localy downloaded image with command:
#qemu-img resize images/focal-server-cloudimg-amd64-disk-kvm.img 10G
resource "libvirt_volume" "os_image" {
  count = length(local.vm_common_list_count)
  name = "os_image.${local.vm_common_list_count[count.index]}"
  pool = "default"
  #source = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-disk-kvm.img"
  #source = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.2.2004-20200611.2.x86_64.qcow2"
  # source = "/media/den/1Tb_wd/images/cloud_images/ubuntu/focal/20211026/focal-server-cloudimg-amd64.img" 
  # source = "/media/den/1Tb_wd/images/cloud_images/ubuntu/focal/20211026/focal-server-cloudimg-amd64-40Gdisk.img"
  source = local.image_path[count.index]
  format = "qcow2"
}

# Use CloudInit ISO to add ssh-key to the instance
resource "libvirt_cloudinit_disk" "commoninit" {
          count = length(local.vm_common_list_count)
          name = "${local.vm_common_list_count[count.index]}-commoninit.iso"
          #name = "${local.vm_common_list_count}-commoninit.iso"
          # pool = "default"
          user_data = data.template_file.user_data[count.index].rendered
          network_config = data.template_file.network_config.rendered
}

data "template_file" "user_data" {
  count = length(local.vm_common_list_count)
  template = file("${path.module}/cloud_init_ubuntu.cfg")
  vars = {
    hostname = element(local.vm_common_list_count, count.index)
    fqdn = "${local.vm_common_list_count[count.index]}.${var.domain}"
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config_dhcp.cfg")
}

# Create the machine
resource "libvirt_domain" "domain-ubuntu" {
  count = length(local.vm_common_list_count)
  name = "${local.vm_common_list_count[count.index]}"
  running = var.vm_condition_poweron
  # if list element contains "m"- master node, use defaults, otherwise (worker)- multiply *4
  memory = local.mem_local_var[count.index]
  vcpu = local.cpu_local_var[count.index]
  disk {
       volume_id = element(libvirt_volume.os_image.*.id, count.index)
  }

  network_interface {
       network_name = "default"
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  # IMPORTANT
  # Ubuntu can hang is a isa-serial is not present at boot time.
  # If you find your cpu 100% and never is available this is why
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = "true"
  }
}


output "vm_list" {
  value = local.vm_common_list_count
}

output "vm_cpu" {
  value = local.cpu_local_var
}

output "vm_images" {
  value = local.image_path
}


output "ips" {
  # show IP, run 'terraform refresh' if not populated
  value = libvirt_domain.domain-ubuntu.*.network_interface.0.addresses
}


resource "null_resource" "shutdowner" {
  # iterate with for_each over Vms list
  for_each = toset(local.vm_common_list_count)
  triggers = {
    trigger = var.vm_condition_poweron
  }

  provisioner "local-exec" {
    # command = var.vm_condition_poweron?"echo 'do nothing'":"for i in $(virsh -c qemu:///system list --all|tail -n+3|awk '{print $2}'); do virsh -c qemu:///system shutdown $i; done"
    command = var.vm_condition_poweron?"echo 'do nothing'":"virsh -c qemu:///system shutdown ${each.value}"
  }
}


# to shutdown execute 
# terraform apply -auto-approve -var 'vm_condition_poweron=false'
