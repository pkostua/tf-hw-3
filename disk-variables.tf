variable "storage_prefix" {
  type = string
  default = "storage"
  description = "storage block names prefix"
}

variable "storage_disk_size" {
  type = number
  default = 1
  description = "Определяет рабмер одного диска storage"
}

variable "storage_disk_count" {
  type    = number
  default = 3
  description = "Определяет число досков, подключаемых к вм storage"
}