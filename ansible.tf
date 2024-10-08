
locals {

  #Собираются данные ВМ БД
  db_vms= [
    for vm in yandex_compute_instance.db : {
      name    = vm.name
      external_ip = vm.network_interface[0].nat_ip_address
      fqdn       =  vm.fqdn
      #For task 5
      id   = vm.id
      #For task 6
      internal_ip = vm.network_interface[0].ip_address
    }
  ]

  #Собираются данные ВМ WEB
  web_vms= [
    for vm in yandex_compute_instance.web : {
      name    = vm.name
      external_ip = vm.network_interface[0].nat_ip_address
      fqdn       =  vm.fqdn
      #For task 5
      id   = vm.id
      #For task 6
      internal_ip = vm.network_interface[0].ip_address
    }
  ]


  #По условию задания код должен работать с ВМ от 2 до 999, но конкретно эта ВМ создается в единственном экземпляре.
  #Гарантированно метода по преобразованию объекта любого тива в массив я не нашел, но конструкция .* покрывает вм, созданные в единственном эксемляре и созданные с помощью count.
  #Для ВМ, созданных с помощью цикла это не работает
  storage_vms= [
    for vm in yandex_compute_instance.storage.*: {
      name    = vm.name
      external_ip = vm.network_interface[0].nat_ip_address
      fqdn       =  vm.fqdn
      #For task 5
      id   = vm.id
      #For task 6
      internal_ip = vm.network_interface[0].ip_address
    }
  ]
}

#Передача переменных в шаблон
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"
  content  = templatefile("${path.module}/inventory.tftpl", {
    web_vms   = local.web_vms
    db_vms    = local.db_vms
    storage_vms = local.storage_vms
  })
}

# null_resource для запуска ansible-playbook

resource "null_resource" "web_hosts_provision" {
  #Ждем создания инстанса
  depends_on = [yandex_compute_instance.web]

  #Добавление ПРИВАТНОГО ssh ключа в ssh-agent
  provisioner "local-exec" {
    command = "eval $(ssh-agent) && cat ~/.ssh/id_ed25519 | ssh-add -"
    on_failure  = continue #Продолжить выполнение terraform pipeline в случае ошибок

  }

  #Костыль!!! Даем ВМ 60 сек на первый запуск. Лучше выполнить это через wait_for port 22 на стороне ansible
  # # В случае использования cloud-init может потребоваться еще больше времени
  # provisioner "local-exec" {
  #   command = "sleep 60"
  # }

  #Запуск ansible-playbook
  provisioner "local-exec" {
    command = <<EOT
          ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${abspath(path.module)}/inventory.ini ${abspath(path.module)}/playbook.yml
    EOT
  }

}
