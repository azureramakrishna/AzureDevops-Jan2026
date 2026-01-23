module "remote_appservice" {
  source = "git::https://github.com/azureramakrishna/AzureDevops-Jan2026.git//Terraform/AppService"

  ressource_group_name_01 = "remote-rg"
  location                = "Canada Central"
  tags = {
    Environment = "remote"
    Project     = "TerraformAppService"
  }
  app_service_plan_name = "remote-appservice-plan"
  app_service_name      = "remote754897748"
}