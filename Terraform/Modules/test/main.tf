module "test_vm" {
  source = "../../"

  ressource_group_name        = var.test_resource_group_name
  location                    = var.location
  tags                        = var.test_tags
  virtual_network_name        = var.test_virtual_network_name
  virtual_network_address     = var.test_virtual_network_address
  subnet_name                 = var.test_subnet_name
  subnet_address              = var.test_subnet_address
  network_security_group_name = var.test_network_security_group_name
  nic_name                    = var.test_nic_name
  virtual_machine_name        = var.test_virtual_machine_name
  virtual_machine_size        = var.test_virtual_machine_size
  admin_username              = var.test_admin_username
  admin_password              = var.test_admin_password
}