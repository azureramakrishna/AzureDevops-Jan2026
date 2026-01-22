variable "ressource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "storage_account_name" {
  type = list(string)
}

