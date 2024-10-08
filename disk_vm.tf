#Создается массив дисков
resource "yandex_compute_disk" "storage_disk" {
  count = var.storage_disk_count

  name = "${var.storage_prefix}-disk-${count.index}"
  size = var.storage_disk_size
  zone = var.default_zone
}

#Создается ВМ и подключается дисковый массив
resource "yandex_compute_instance" "storage" {
  name        = var.storage_prefix
  platform_id = var.default_platform_id
  zone        = var.default_zone

  resources {
    cores  = var.vms_resources[var.storage_prefix].cores
    memory = var.vms_resources[var.storage_prefix].memory
    core_fraction  = var.vms_resources[var.storage_prefix].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  #Подключение дисков
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk

    content {
      disk_id = secondary_disk.value.id
    }
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = local.ssh_key
  }


}