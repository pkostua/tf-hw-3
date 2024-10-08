###vm vars

variable "default_platform_id" {
  type = string
  default = "standard-v3"
}

variable "vm_family_ubuntu" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "https://yandex.cloud/ru/docs/compute/concepts/image"
}

variable "vms_resources" {
  type        = map( object({
    core_fraction: number,
    cores: number,
    memory: number,
  }))
  default = {
    web={
      cores=2
      memory=1
      core_fraction=20
    },
    storage = {
      cores=2
      memory=2
      core_fraction=20
    }
  }
  description = "Определяет параметры ВМ storage и web"
}

variable "web_vm_name_prefix" {
  type = string
  default = "web"
  description = "Prefix of the name of web server machines"
}

#Этот список нужно объединить с vms_resources. Обязательно буду так делать в будущем, но сейчас это будет нарушением условия задания
variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
    core_fraction = number
  }))

  default = [
    {
      vm_name     = "main"
      cpu         = 2
      ram         = 2
      disk_volume = 20
      core_fraction = 20
    },
    {
      vm_name     = "replica"
      cpu         = 2
      ram         = 1
      disk_volume = 30
      core_fraction = 20
    }
  ]
  description = "Список, определяющий состав и параметры ВМ DB"
}
