locals{

  #Давайте добавим в вывод еще и storage, Тем более что почти вся работа уже сделана в 4 задании
  all_vms = concat(local.db_vms, concat(local.web_vms, local.storage_vms))

}
output "vm_list" {
  value = [
    for vm in local.all_vms : {
      name = vm.name
      id   = vm.id
      fqdn = vm.fqdn
    }
  ]
}