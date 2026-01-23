variable "ressource_group_name_01" {
  type        = string
  description = "Name of the resource group 01"
  default     = "saanvikit-rg-01"
}

variable "location" {
  type    = string
  default = "Canada Central"
}

variable "tags" {
  type = map(string)
  default = {
    "Project"     = "Terraform"
    "Environment" = "DEV"
  }
}

variable "app_service_plan_name" {
  type    = string
  default = "saanvikit-app-serviceplan"
}

variable "app_service_name" {
  type    = string
  default = "saanvikit21012026"

}

