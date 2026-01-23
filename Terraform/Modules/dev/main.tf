module "dev_vm" {
  source = "../../"

  ressource_group_name        = var.dev_resource_group_name
  location                    = var.location
  tags                        = var.dev_tags
  virtual_network_name        = var.dev_virtual_network_name
  virtual_network_address     = var.dev_virtual_network_address
  subnet_name                 = var.dev_subnet_name
  subnet_address              = var.dev_subnet_address
  network_security_group_name = var.dev_network_security_group_name
  nic_name                    = var.dev_nic_name
  virtual_machine_name        = var.dev_virtual_machine_name
  virtual_machine_size        = var.dev_virtual_machine_size
  admin_username              = var.dev_admin_username
  admin_password              = var.dev_admin_password
}