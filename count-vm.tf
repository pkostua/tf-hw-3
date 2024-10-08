#Создается массив ВМ web
resource "yandex_compute_instance" "web" {
  count = 2

  name = "${var.web_vm_name_prefix}-${count.index + 1}"

  platform_id = var.default_platform_id
  zone        = var.default_zone

  resources {
    cores    = var.vms_resources[var.web_vm_name_prefix].cores
    memory   = var.vms_resources[var.web_vm_name_prefix].memory
    core_fraction = var.vms_resources[var.web_vm_name_prefix].core_fraction

  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  #Подключается группа безопасности
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat     = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = local.ssh_key
  }

  depends_on = [yandex_compute_instance.db]


}