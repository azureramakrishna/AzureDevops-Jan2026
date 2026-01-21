variable "ressource_group_name_01" {
  type        = string
  description = "Name of the resource group 01"
  default     = "saanvikit-rg-01"
}

variable "ressource_group_name_02" {
  type        = string
  description = "Name of the resource group 02"
  default     = "saanvikit-rg-02"
}

variable "location" {
  type    = string
  default = "Canada Central"
}

variable "storage_account_name" {
  type    = string
  default = "Saanvikit20012026"
}

variable "tags" {
  type = map(string)
  default = {
    "Project"     = "Terraform"
    "Environment" = "DEV"
  }
}

variable "pip_name" {
  type    = string
  default = "saanvikit-pip"
}

variable "app_service_plan_name" {
  type    = string
  default = "saanvikit-app-serviceplan"
}

variable "app_service_name" {
  type    = string
  default = "saanvikit21012026"
}