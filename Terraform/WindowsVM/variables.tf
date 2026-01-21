variable "ressource_group_name" {
  type        = string
  description = "Name of the resource group 01"
  default     = "terraform-rg-windowsvm"
}

variable "location" {
  type    = string
  default = "central india"
}

variable "tags" {
  type = map(string)
  default = {
    "Project"     = "Terraform"
    "Environment" = "DEV"
  }
}

variable "network_security_group_name" {
  type    = string
  default = "terraform-nsg"
}

variable "nic_name" {
  type    = string
  default = "terraform-nic"
}

variable "virtual_machine_name" {
  type    = string
  default = "terraform-vm"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}