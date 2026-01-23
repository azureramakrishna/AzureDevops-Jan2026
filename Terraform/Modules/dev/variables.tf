variable "dev_resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "dev_tags" {
  type = map(string)
}

variable "dev_virtual_network_name" {
  type = string
}

variable "dev_virtual_network_address" {
  type = list(string)
}

variable "dev_subnet_name" {
  type = string
}

variable "dev_subnet_address" {
  type = list(string)
}

variable "dev_network_security_group_name" {
  type = string
}

variable "dev_nic_name" {
  type = string
}

variable "dev_virtual_machine_name" {
  type = string
}

variable "dev_virtual_machine_size" {
  type = string
}

variable "dev_admin_username" {
  type = string
}

variable "dev_admin_password" {
  type = string
}