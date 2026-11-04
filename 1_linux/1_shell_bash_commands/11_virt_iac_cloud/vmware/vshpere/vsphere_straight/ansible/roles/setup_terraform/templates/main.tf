{% if application == 'APP1' %}
  {% set vm_count = 4 %}
  {% set vm_names = ['app', 'sys', 'redis', 'pg'] %}
{% elif application == 'APP2' %}
  {% set vm_count = 4 %}
  {% set vm_names = ['app', 'back', 'sys', 'redis'] %}
{% elif application == 'APP3' %}
  {% set vm_count = 1 %}
  {% set vm_names = ['app'] %}
{% endif %}
{% set vm_count = vm_count|int %}
{% set cpu = cpu|int %}
{% set memory = memory|int %}
{% set storage = storage|int %}

# see https://github.com/hashicorp/terraform
terraform {
  required_version = ">= 1.2.2"
  required_providers {
    # see https://registry.terraform.io/providers/hashicorp/random
    random = {
      source = "hashicorp/random"
      version = ">= 3.1.1"
    }
    # see https://registry.terraform.io/providers/hashicorp/template
    template = {
      source = "hashicorp/template"
      version = ">= 2.2.0"
    }
    # see https://registry.terraform.io/providers/hashicorp/vsphere
    # see https://github.com/hashicorp/terraform-provider-vsphere
    vsphere = {
      source = "hashicorp/vsphere"
      version = ">= 2.1.0"
    }
  }
}

variable "vm_count" {
  description = "number of VMs to create"
  type = number
  default = {{ vm_count }}
}

variable "vm_cpu" {
  description = "number of CPUs per VM"
  type = number
  default = {{ cpu }}
}

variable "vm_memory" {
  description = "amount of memory [GiB] per VM"
  type = number
  default = {{ memory }}
}

variable "vm_disk_os_size" {
  description = "minimum size of the OS disk [GiB]"
  type = number
  default = {{ storage }}
}

variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
variable "hostname" {
  default = "u20vm"
}

variable "ssh_key" {
  default = ""
}

variable "vsphere_datacenter" {
  default = "Prod"
}

variable "vsphere_compute_cluster" {
  default = "Prod-cluster"
}

variable "vsphere_network" {
  default = "VLAN_0000(Prod vDS)(vra)"
}

variable "vsphere_datastore" {
  default = "PROD-Store-01"
}

variable "vsphere_folder" {
  default = "Tst VMs(vrsa)/000-005"
}

variable "vsphere_ubuntu_template" {
  # default = "v00ubuntu20-04for1cdevops-template"
  # default = "ubuntu-focal-20.04-cloudimg"
  default = "ubuntu-focal-20.04-for-devops"
}

variable "vsphere_res_pool" {
  default = "PROD-Pool-01"
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_res_pool
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "ubuntu_template" {
  name = var.vsphere_ubuntu_template
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

provider "vsphere" {
  user = var.vsphere_user
  password = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}


# see https://www.terraform.io/docs/providers/vsphere/r/virtual_machine.html
resource "vsphere_virtual_machine" "linux-vm" {
  count = var.vm_count
  folder = var.vsphere_folder
  name = "${var.hostname}${count.index}"
  guest_id = "ubuntu64Guest"
  firmware = data.vsphere_virtual_machine.ubuntu_template.firmware
  num_cpus = var.vm_cpu
  num_cores_per_socket = var.vm_cpu
  memory = var.vm_memory*1024
  enable_disk_uuid = true # NB the VM must have disk.EnableUUID=1 for, e.g., k8s persistent storage.
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id = data.vsphere_datastore.datastore.id
  scsi_type = data.vsphere_virtual_machine.ubuntu_template.scsi_type
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = -1
  disk {
    label = "os"
    eagerly_scrub    = data.vsphere_virtual_machine.ubuntu_template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.ubuntu_template.disks.0.thin_provisioned
    size = var.vm_disk_os_size
    unit_number = 0
  }


  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.ubuntu_template.network_interface_types.0
  }

  vapp {
    properties = {
      # "hostname" = "${var.name}0${count.index + 1}"
      "hostname" = "${var.hostname}${count.index}"
      "public-keys" = var.ssh_key
      "user-data" = base64encode(file("./cloudinit_configs/kickstart-python${count.index}.yaml"))
      "password" = "ubuntu"
      "instance-id" = "${count.index + 1}"
    }
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu_template.id
  }
}

output "ips" {
  value = vsphere_virtual_machine.linux-vm.*.default_ip_address
}
