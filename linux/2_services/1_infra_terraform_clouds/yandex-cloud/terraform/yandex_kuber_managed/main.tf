// Configure the Yandex.Cloud provider
# see https://github.com/hashicorp/terraform
terraform {
  required_version = ">= 1.2.2"
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}


provider "yandex" {
  token     = ""
  folder_id = "" #default
  zone      = "ru-central1-a"
}

resource "yandex_iam_service_account" "kube-infra" {
  name        = "kube-infra"
  description = "service account to manage VMs"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id

  role = "editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.kube-infra.id}",
  ]

  depends_on = [
    yandex_iam_service_account.kube-infra
  ]
}


data "yandex_vpc_network" "default" {
  network_id = ""
  # folder_id = "b1g9pa9rd84c2eo472aj"
  # name = var.yandex_vpc_network_name
}

data "yandex_vpc_subnet" "default-subnet" {
  subnet_id = ""
  # name = var.yandex_vpc_subnet_name
}




# https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster

# Создаем кластер кубернетес
resource "yandex_kubernetes_cluster" "kube-infra" {
  # Указываем его имя
  name        = "kube-infra"

  # Указываем, к какой сети он будет подключен
  network_id = data.yandex_vpc_network.default.id

  # Указываем, что мастера располагаются в регионе ru-central и какие subnets использовать для каждой зоны
  master {
    # if multipe nodes
    # regional {
    # if one node
    zonal { 
      # https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster#zone
      #~region = "ru-central1"

      # location {
        zone      = data.yandex_vpc_subnet.default-subnet.zone
        subnet_id = data.yandex_vpc_subnet.default-subnet.id
      }

    #   location {
    #     zone      = yandex_vpc_subnet.internal-b.zone
    #     subnet_id = yandex_vpc_subnet.internal-b.id
    #   }

    #   location {
    #     zone      = yandex_vpc_subnet.internal-c.zone
    #     subnet_id = yandex_vpc_subnet.internal-c.id
    #   }
    

    # Указываем версию Kubernetes
    version   = "1.22"
    # Назначаем внешний ip master нодам, чтобы мы могли подключаться к ним извне
    public_ip = true
  }

  # Указываем канал обновлений
  release_channel = "RAPID"
  network_policy_provider = "CALICO"

  # Указываем сервисный аккаунт, который будут использовать ноды, и кластер для управления нодами
  node_service_account_id = "${yandex_iam_service_account.kube-infra.id}"
  service_account_id      = "${yandex_iam_service_account.kube-infra.id}"

  # Without it, on destroy, terraform will delete cluster and remove access rights for service account(s) simultaneously, 
  # that will cause problems for cluster and related node group deletion.
  depends_on = [
    yandex_iam_service_account.kube-infra
  ]
}

# Создаем группу узлов
# https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group
resource "yandex_kubernetes_node_group" "test-group" {
  # Указываем, к какому кластеру они принадлежат
  cluster_id  = yandex_kubernetes_cluster.kube-infra.id
  # Указываем название группы узлов
  name        = "test-group"
  # И версию
  version     = "1.22"

  # Настраиваем шаблон виртуальной машины
  instance_template {
    platform_id = "standard-v1"
    metadata = {
      ssh_keys = "den:${file("~/.ssh/id_rsa.pub")}"
    }

    network_interface {
      nat = true
      subnet_ids = ["${data.yandex_vpc_subnet.default-subnet.id}"]
    #   subnet_ids = ["${yandex_vpc_subnet.default-subnet.id}", "${yandex_vpc_subnet.internal-b.id}", "${yandex_vpc_subnet.internal-c.id}"]
    }

    resources {
      # core_fraction = 20 # Данный параметр позволяет уменьшить производительность CPU и сильно уменьшить затраты на инфраструктуру
      # the specified memory size is not available with 20 cores and 100% core fraction on platform "standard-v1"; allowed memory size: 20GB, 40GB, 60GB, 80GB, 100GB, 120GB, 140GB, 160GB.
      memory        = 4
      cores         = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 50
    }

    scheduling_policy {
      preemptible = true
    }
  }

  # Настраиваем политику масштабирования — в данном случае у нас группа фиксирована и в ней находятся 2 узла
  scale_policy {
    # fixed_scale {
    #   size = 2
    # }
    auto_scale {
      min = 1
      max = 2
      initial = 1
    }
  }

  # В каких зонах можно создавать машинки — указываем все зоны
  allocation_policy {
    location {
      zone = "ru-central1-a"
    }

    # location {
    #   zone = "ru-central1-b"
    # }

    # location {
    #   zone = "ru-central1-c"
    # }
  }

  # Отключаем автоматический апгрейд
  maintenance_policy {
    auto_upgrade = false
    auto_repair  = true
  }
}
