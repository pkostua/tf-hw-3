# Решение домашнего задания к занятию «Управляющие конструкции в коде Terraform»
https://github.com/netology-code/ter-homeworks/blob/main/03/hw-03.md
## Задание 1
![image](https://github.com/user-attachments/assets/7c7f3e3b-a301-44de-986f-f831378a1300)

## Задание 2-6 Ссылка на комит
https://github.com/pkostua/tf-hw-3/commit/3c105a0fbd5426fd20bdb482fd87bb8c0518ff21#diff-c11cf53fc9f6953630e289e969d451884f20dbe01b17d600f70c147abced2374

## Задание 4
### inventory.ini после шестого задания - два адреса внутренние. Файл создается в ansible.tf
![image](https://github.com/user-attachments/assets/9246f6be-0c30-40bc-9719-c0dd93b9dd28)

## Задание 5
Задание выполнено частично. Не реализована целевая последовательность вывода полей name - id - fqdn. Список сделан на основе результатов 4 задания ansible.tf  
Подскажите пожалуйста есть ли способы управленяи последовательностью отображения полей?
![image](https://github.com/user-attachments/assets/f922bc65-4887-4e80-9cff-9f947e675f56)

## Задание 6
Часть 1 выполнил на всех ВМ из файла inventory.ini запуск playbook описан в файле ansible.tf.   
Часть 2 выполнил частично. Модифицированный шаблон находится в файле inventory.tftpl. Но для применения такого кода нужна еще одна ВМ бастион, поднять такую ВМ через терраформ не составляет проблемы. однако как настроить ansible через ssh proxy да еще и определить тип адреса(внешний внутренний) а может быть установить ansible на бастион?... Видимо эта тема следующей части обучения  
Код в той же ветке

## Задание 7
выражение в terraform console
```
> {  network_id = local.vpc.network_id,     subnet_ids = concat(slice(local.vpc.subnet_ids, 0, 2), slice(local.vpc.subnet_ids, 3, length(local.vpc.subnet_ids))),     subnet_zones = concat(slice(local.vpc.subnet_zones, 0, 2), slice(local.vpc.subnet_zones, 3, length(local.vpc.subnet_zones))) }
```

## Задание 8
Ошибки  
1. В platform_id=${i["platform_id "]} есть лишний пробел в ключе platform_id  
2. В ключе ansible_host нет фигурной закрывающей скобки
3. В конце третей строки есть лишняя закрывающая скобка 
