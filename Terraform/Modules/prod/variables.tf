variable "prod_resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "prod_tags" {
  type = map(string)
}

variable "prod_virtual_network_name" {
  type = string
}

variable "prod_virtual_network_address" {
  type = list(string)
}

variable "prod_subnet_name" {
  type = string
}

variable "prod_subnet_address" {
  type = list(string)
}

variable "prod_network_security_group_name" {
  type = string
}

variable "prod_nic_name" {
  type = string
}

variable "prod_virtual_machine_name" {
  type = string
}

variable "prod_virtual_machine_size" {
  type = string
}

variable "prod_admin_username" {
  type = string
}

variable "prod_admin_password" {
  type = string
}