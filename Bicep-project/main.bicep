metadata name = 'Azure vNet Peering Architecture'
metadata description = 'Creates two Virtual Networks with vNet peering for Company A (Sales and Marketing departments)'

param location string = 'eastus'
param environment string = 'dev'
param projectName string = 'saanvikit'
param deployVMs bool = true

@minLength(1)
@maxLength(11)
param vmAdminUsername string = 'azureuser'

@secure()
@minLength(12)
param vmAdminPassword string

param joinDomain bool = true
param domainName string = 'contoso.com'
param domainOuPath string = 'OU=Servers,DC=contoso,DC=com'

@minLength(1)
param domainAdminUsername string = 'domainadmin'

@secure()
@minLength(12)
param domainAdminPassword string = 'DomainP@ss123456'

param dnsServers array = [
  '192.168.1.10'
  '192.168.1.11'
]

// Variable definitions for resource naming and configuration
var suffix = '${projectName}-${environment}'

// Sales vNET Configuration
var salesVnetName = 'vnet-${suffix}-sales'
var salesSubnetName = 'subnet-${suffix}-sales'
var salesVnetAddressSpace = '10.0.0.0/16'
var salesSubnetAddressRange = '10.0.0.0/24'
var salesVMName = 'vm-${suffix}-sales'
var salesNicName = 'nic-${suffix}-sales'
var salesNsgName = 'nsg-${suffix}-sales'
var salesPublicIpName = 'pip-${suffix}-sales'

// Marketing vNET Configuration
var marketingVnetName = 'vnet-${suffix}-marketing'
var marketingSubnetName = 'subnet-${suffix}-marketing'
var marketingVnetAddressSpace = '10.1.0.0/16'
var marketingSubnetAddressRange = '10.1.0.0/24'
var marketingVMName = 'vm-${suffix}-marketing'
var marketingNicName = 'nic-${suffix}-marketing'
var marketingNsgName = 'nsg-${suffix}-marketing'
var marketingPublicIpName = 'pip-${suffix}-marketing'

// vNet Peering Configuration
var salesToMarketingPeeringName = 'peer-${suffix}-sales-to-marketing'
var marketingToSalesPeeringName = 'peer-${suffix}-marketing-to-sales'

// VM Configuration
var vmSize = 'Standard_Ds1_v2'
var salesComputerName = 'sales-01'
var marketingComputerName = 'mkt-01'
var imagePublisher = 'MicrosoftWindowsServer'
var imageOffer = 'WindowsServer'
var imageSku = '2022-Datacenter'
var imageVersion = 'latest'

// ============================================================================
// Sales Department Resources
// ============================================================================

// Sales Network Security Group
resource salesNsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: salesNsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowVNetInbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 1001
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowDNS'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '53'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1002
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowLDAP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '389'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1003
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowLDAPS'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '636'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1004
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowKerberos'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '88'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1005
          direction: 'Outbound'
        }
      }
    ]
  }
}

// Sales Public IP Address
resource salesPublicIp 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: salesPublicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

// Sales Virtual Network
resource salesVnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: salesVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        salesVnetAddressSpace
      ]
    }
    dhcpOptions: {
      dnsServers: dnsServers
    }
    subnets: [
      {
        name: salesSubnetName
        properties: {
          addressPrefix: salesSubnetAddressRange
          networkSecurityGroup: {
            id: salesNsg.id
          }
        }
      }
    ]
  }
}

// Sales Network Interface
resource salesNic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: salesNicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${salesVnet.id}/subnets/${salesSubnetName}'
          }
          privateIPAddress: '10.0.0.4'
          privateIPAllocationMethod: 'Static'
          publicIPAddress: {
            id: salesPublicIp.id
          }
        }
      }
    ]
  }
}

// Sales Virtual Machine
resource salesVM 'Microsoft.Compute/virtualMachines@2023-09-01' = if (deployVMs) {
  name: salesVMName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: salesComputerName
      adminUsername: vmAdminUsername
      adminPassword: vmAdminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: imageVersion
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: salesNic.id
        }
      ]
    }
  }
}

// Sales VM - Domain Join Extension
resource salesDomainJoinExtension 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' = if (deployVMs && joinDomain) {
  parent: salesVM
  name: 'JsonADDomainExtension'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: {
      Name: domainName
      OUPath: domainOuPath
      User: '${domainName}\\${domainAdminUsername}'
      Restart: 'true'
      Options: '3'
    }
    protectedSettings: {
      Password: domainAdminPassword
    }
  }
}

// ============================================================================
// Marketing Department Resources
// ============================================================================

// Marketing Network Security Group
resource marketingNsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: marketingNsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowVNetInbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 1001
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowDNS'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '53'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1002
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowLDAP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '389'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1003
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowLDAPS'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '636'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1004
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowKerberos'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '88'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1005
          direction: 'Outbound'
        }
      }
    ]
  }
}

// Marketing Public IP Address
resource marketingPublicIp 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: marketingPublicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

// Marketing Virtual Network
resource marketingVnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: marketingVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        marketingVnetAddressSpace
      ]
    }
    dhcpOptions: {
      dnsServers: dnsServers
    }
    subnets: [
      {
        name: marketingSubnetName
        properties: {
          addressPrefix: marketingSubnetAddressRange
          networkSecurityGroup: {
            id: marketingNsg.id
          }
        }
      }
    ]
  }
}

// Marketing Network Interface
resource marketingNic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: marketingNicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${marketingVnet.id}/subnets/${marketingSubnetName}'
          }
          privateIPAddress: '10.1.0.4'
          privateIPAllocationMethod: 'Static'
          publicIPAddress: {
            id: marketingPublicIp.id
          }
        }
      }
    ]
  }
}

// Marketing Virtual Machine
resource marketingVM 'Microsoft.Compute/virtualMachines@2023-09-01' = if (deployVMs) {
  name: marketingVMName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: marketingComputerName
      adminUsername: vmAdminUsername
      adminPassword: vmAdminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: imageVersion
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: marketingNic.id
        }
      ]
    }
  }
}

// Marketing VM - Domain Join Extension
resource marketingDomainJoinExtension 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' = if (deployVMs && joinDomain) {
  parent: marketingVM
  name: 'JsonADDomainExtension'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: {
      Name: domainName
      OUPath: domainOuPath
      User: '${domainName}\\${domainAdminUsername}'
      Restart: 'true'
      Options: '3'
    }
    protectedSettings: {
      Password: domainAdminPassword
    }
  }
}

// ============================================================================
// vNET Peering Configuration
// ============================================================================

// Sales to Marketing vNET Peering
resource salesToMarketingPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: salesVnet
  name: salesToMarketingPeeringName
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: marketingVnet.id
    }
  }
}

// Marketing to Sales vNET Peering
resource marketingToSalesPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: marketingVnet
  name: marketingToSalesPeeringName
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: salesVnet.id
    }
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('Sales vNET resource ID')
output salesVnetId string = salesVnet.id

@description('Marketing vNET resource ID')
output marketingVnetId string = marketingVnet.id

@description('Sales subnet resource ID')
output salesSubnetId string = '${salesVnet.id}/subnets/${salesSubnetName}'

@description('Marketing subnet resource ID')
output marketingSubnetId string = '${marketingVnet.id}/subnets/${marketingSubnetName}'

@description('Sales VM Private IP Address')
output salesVmPrivateIpAddress string = salesNic.properties.ipConfigurations[0].properties.privateIPAddress

@description('Sales VM Public IP Address')
output salesVmPublicIpAddress string = salesPublicIp.properties.ipAddress

@description('Marketing VM Private IP Address')
output marketingVmPrivateIpAddress string = marketingNic.properties.ipConfigurations[0].properties.privateIPAddress

@description('Marketing VM Public IP Address')
output marketingVmPublicIpAddress string = marketingPublicIp.properties.ipAddress

@description('Sales to Marketing Peering Status')
output salesToMarketingPeeringId string = salesToMarketingPeering.id

@description('Marketing to Sales Peering Status')
output marketingToSalesPeeringId string = marketingToSalesPeering.id
