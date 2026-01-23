test_resource_group_name = "test-rg"
location                 = "East US"
test_tags = {
  Environment = "test"
  Project     = "TerraformAzureVM"
}
test_virtual_network_name        = "test-vnet"
test_virtual_network_address     = ["10.0.1.0/24"]
test_subnet_name                 = "test-subnet"
test_subnet_address              = ["10.0.1.0/24"]
test_network_security_group_name = "test-nsg"
test_nic_name                    = "test-nic"
test_virtual_machine_name        = "test-vm"
test_virtual_machine_size        = "Standard_B1s"
test_admin_username              = "azureuser"
test_admin_password              = "P@ssw0rd1234!"