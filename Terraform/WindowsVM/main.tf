# Create a resource group 01
resource "azurerm_resource_group" "rg" {
  name     = var.ressource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate NSG to subnet
resource "azurerm_subnet_network_security_group_association" "example" {
  depends_on                = [azurerm_network_security_group.nsg, data.azurerm_subnet.example]
  subnet_id                 = data.azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a NIC
resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# Create a Windows VM
resource "azurerm_windows_virtual_machine" "example" {
  depends_on          = [azurerm_network_interface.nic]
  name                = var.virtual_machine_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"
  tags                = var.tags
  admin_username      = var.admin_username
  admin_password      = data.azurerm_key_vault_secret.example.value
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-Datacenter"
    version   = "latest"
  }
}

# Create a data disk
resource "azurerm_managed_disk" "example" {
  name                 = "${var.virtual_machine_name}-data-disk-01" // saanvikit-vm-data-disk-01
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

# Attach the data disk to the VM
resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.example.id
  virtual_machine_id = azurerm_windows_virtual_machine.example.id
  lun                = "1"
  caching            = "ReadWrite"
}