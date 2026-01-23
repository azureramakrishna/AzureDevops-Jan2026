dev_resource_group_name = "dev-rg"
location                = "East US"
dev_tags = {
  Environment = "Development"
  Project     = "TerraformAzureVM"
}
dev_virtual_network_name        = "dev-vnet"
dev_virtual_network_address     = ["10.0.0.0/24"]
dev_subnet_name                 = "dev-subnet"
dev_subnet_address              = ["10.0.0.0/24"]
dev_network_security_group_name = "dev-nsg"
dev_nic_name                    = "dev-nic"
dev_virtual_machine_name        = "dev-vm"
dev_virtual_machine_size        = "Standard_B1s"
dev_admin_username              = "azureuser"
dev_admin_password              = "P@ssw0rd1234!"