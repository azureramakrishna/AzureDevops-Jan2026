module "prod_vm" {
  source = "../../"

  ressource_group_name        = var.prod_resource_group_name
  location                    = var.location
  tags                        = var.prod_tags
  virtual_network_name        = var.prod_virtual_network_name
  virtual_network_address     = var.prod_virtual_network_address
  subnet_name                 = var.prod_subnet_name
  subnet_address              = var.prod_subnet_address
  network_security_group_name = var.prod_network_security_group_name
  nic_name                    = var.prod_nic_name
  virtual_machine_name        = var.prod_virtual_machine_name
  virtual_machine_size        = var.prod_virtual_machine_size
  admin_username              = var.prod_admin_username
  admin_password              = var.prod_admin_password
}