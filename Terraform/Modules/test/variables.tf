variable "test_resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "test_tags" {
  type = map(string)
}

variable "test_virtual_network_name" {
  type = string
}

variable "test_virtual_network_address" {
  type = list(string)
}

variable "test_subnet_name" {
  type = string
}

variable "test_subnet_address" {
  type = list(string)
}

variable "test_network_security_group_name" {
  type = string
}

variable "test_nic_name" {
  type = string
}

variable "test_virtual_machine_name" {
  type = string
}

variable "test_virtual_machine_size" {
  type = string
}

variable "test_admin_username" {
  type = string
}

variable "test_admin_password" {
  type = string
}