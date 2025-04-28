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
      version = ">= 2.1.1"
    }
    vra7 = {
      source = "vmware/vra7"
      version = "3.0.1"
    }
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}