# variable "token" {}
# variable "service_account_key_file" {}
#variable "cloud_id" {}
variable "folder_id" {}
variable "zone" {}




variable yandex_vpc_network_name {
  default = "default"
  # default = "net"
}
variable yandex_vpc_subnet_name {
  default = "default-ru-central1-a"
  # default = "net-a"
}
