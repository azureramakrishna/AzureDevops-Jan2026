param storage_account_name string
param location string = resourceGroup().location
param virtual_network_name string
param virtual_network_address array
param subnet_name string
param subnet_address string
param public_ip_name string
param network_security_group string
param network_interface_name string
param windows_vm_name string
param windows_vm_size string
param adminUser string
@secure()
param adminPassword string

var tags = {
  Environment: 'DEV'
  Project: 'Bicep'
  Location: 'EastUS'
}

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storage_account_name
  location: location
  kind: 'StorageV2'
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtual_network_name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: virtual_network_address
    }
    subnets: [
      {
        name: subnet_name
        properties: {
          addressPrefix: subnet_address
        }
      }
    ]
  }
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: public_ip_name
  location: location
  tags: tags
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: network_security_group
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'Allow_RDP'
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow_HTTP'
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 200
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: network_interface_name
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'saanvikit-nic'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress:{
            id: publicIPAddress.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtual_network_name, subnet_name)
          }
        }
      }
    ]
  }
}

resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: windows_vm_name
  location: location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: windows_vm_size
    }
    osProfile: {
      computerName: windows_vm_name
      adminUsername: adminUser
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: 'name'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}




