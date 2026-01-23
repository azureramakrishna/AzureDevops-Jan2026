prod_resource_group_name = "prod-rg"
location                 = "East US"
prod_tags = {
  Environment = "prod"
  Project     = "TerraformAzureVM"
}
prod_virtual_network_name        = "prod-vnet"
prod_virtual_network_address     = ["10.0.2.0/24"]
prod_subnet_name                 = "prod-subnet"
prod_subnet_address              = ["10.0.2.0/24"]
prod_network_security_group_name = "prod-nsg"
prod_nic_name                    = "prod-nic"
prod_virtual_machine_name        = "prod-vm"
prod_virtual_machine_size        = "Standard_B1s"
prod_admin_username              = "azureuser"
prod_admin_password              = "P@ssw0rd1234!"