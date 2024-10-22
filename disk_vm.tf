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
  #Вариант 1. Прямая передача идентификатора диска из текщего объекта счетчика
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk

    content {
      disk_id = secondary_disk.value.id
    }
  }

  #Вариант 2. Общее оформление счетчика  + идентифкатор достается из исходного массива через указатель
  dynamic "secondary_disk" {
    for_each = {for key,value in yandex_compute_disk.storage_disk: key => value}

    content {
      disk_id = yandex_compute_disk.storage_disk[secondary_disk.key].id
    }
  }

  #Вариант 3. Исходный массив размапить на список идентификаторов, идентификатор записать как текущий объект счиетчика
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk.*.id

    content {
      disk_id = secondary_disk.value
    }
  }

  #Вариант 4. Как вариант 3, но за идентификатором идем в исходный массив
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk.*.id

    content {
      disk_id = yandex_compute_disk.storage_disk[secondary_disk.key].id
    }
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = local.ssh_key
  }


}