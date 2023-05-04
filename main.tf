terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">=0.84.0"
    }
  }
}

# Документация по провайдеру: https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs#configuration-reference
# Настраиваем the Yandex.Cloud provider
# Данные для подключения к провайдеру
provider "yandex" {
  token     = var.yandex_cloud_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
  zone      = var.zone[0]
}

# Создаём сеть между контейнерами с названием "swarm-network"
resource "yandex_vpc_network" "network" {
  name = "swarm-network"
}

# Создаём локальную сеть между нодами - ВМ
resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet1"
  zone           = var.zone[0]
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Создание swarm кластера согласно вложенному модулю
module "swarm_cluster" {
  source        = "./modules/instance"
  vpc_subnet_id = yandex_vpc_subnet.subnet.id
  managers      = 1
  workers       = 2
}