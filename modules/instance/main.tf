data "yandex_compute_image" "my_image" {
  family = var.instance_family_image
}

# Создаём ВМ - ноду с ролью менеджера
resource "yandex_compute_instance" "vm-manager" {
  count    = var.managers
  name     = "ci-sockshop-docker-swarm-manager-${count.index}"
  hostname = "manager-${count.index}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = 15
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

# SSH ключ для доступа к ВМ - нодам. Ключи создаём без пароля, Terraform не умеет работать с парольными ключами.
  metadata = {
    ssh-keys = "${var.ssh_credentials.user}:${file(var.ssh_credentials.pub_key)}"
  }

}

# Создаём ВМ - ноду с ролью воркера
resource "yandex_compute_instance" "vm-worker" {
  count    = var.workers
  name     = "ci-sockshop-docker-swarm-worker-${count.index}"
  hostname = "worker-${count.index}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = 15
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

# SSH ключ для доступа к ВМ - нодам. Ключи создаём без пароля, Terraform не умеет работать с парольными ключами.
  metadata = {
    ssh-keys = "${var.ssh_credentials.user}:${file(var.ssh_credentials.pub_key)}"
  }

}