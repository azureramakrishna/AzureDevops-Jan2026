using 'main.bicep'

param storage_account_name = 'saanvikit12012026'
param virtual_network_name = 'saanvikit-vnet'
param virtual_network_address = ['192.168.0.0/24']
param subnet_name = 'saanvikit-snet'
param subnet_address = '192.168.0.0/24'
param public_ip_name = 'saanvikit-pip'
param network_security_group = 'saanvikit-nsg'
param network_interface_name = 'saanvikit-nic'
param windows_vm_name = 'saanvikit-vm'
param windows_vm_size = 'Standard_D2S_V3'
param adminUser = 'azureuser'
