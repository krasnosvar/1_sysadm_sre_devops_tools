terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}


# yc vpc security-group create --name yc-security-group --network-name default \
# --rule 'direction=ingress,port=443,protocol=tcp,v4-cidrs=0.0.0.0/0' \
# --rule 'direction=ingress,port=80,protocol=tcp,v4-cidrs=0.0.0.0/0' \
# --rule 'direction=ingress,from-port=0,to-port=65535,protocol=any,predefined=self_security_group' \
# --rule 'direction=ingress,from-port=0,to-port=65535,protocol=any,v4-cidrs=[10.96.0.0/16,10.112.0.0/16]' \
# --rule 'direction=ingress,from-port=0,to-port=65535,protocol=tcp,v4-cidrs=[198.18.235.0/24,198.18.248.0/24]' \
# --rule 'direction=egress,from-port=0,to-port=65535,protocol=any,v4-cidrs=0.0.0.0/0' \
# --rule 'direction=ingress,protocol=icmp,v4-cidrs=[10.0.0.0/8,192.168.0.0/16,172.16.0.0/12]' 


provider "yandex" {
  token     = ""
  folder_id = "" #default
  zone      = "ru-central1-a"
}


resource "yandex_vpc_network" "default" {
  name      = "default-net"
  folder_id = ""
}

resource "yandex_vpc_subnet" "default-subnet-a" {
  name           = "default-subnet"
  v4_cidr_blocks = ["10.0.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
}


# data "yandex_vpc_network" "default" {}


resource "yandex_vpc_security_group" "yc-security-group" {
  name        = "default security group"
  description = "Description for security group"
  # network_id  = data.default.network_id
  network_id  = "${yandex_vpc_network.default.id}"


  ingress {
    protocol       = "TCP"
    # description    = "Rule description 1"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    # description    = "Rule description 1"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol          = "ANY"
    # description     = "Rule description 2"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol          = "ANY"
    # description     = "Rule description 2"
    v4_cidr_blocks  = ["10.96.0.0/16", "10.112.0.0/16"]
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol          = "TCP"
    # description     = "Rule description 2"
    v4_cidr_blocks  = ["198.18.235.0/24", "198.18.248.0/24"]
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol          = "ICMP"
    # description     = "Rule description 2"
    v4_cidr_blocks  = ["10.0.0.0/8","192.168.0.0/16","172.16.0.0/12"]
    # from_port         = 0
    # to_port           = 65535
  }

  egress {
    protocol       = "ANY"
    description    = "Egress rule"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 8090
    to_port        = 8099
  }
}
