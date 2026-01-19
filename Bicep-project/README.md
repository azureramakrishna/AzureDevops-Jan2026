# Azure vNet Peering Architecture - Bicep Template

This Bicep template creates a complete Azure infrastructure for Company A with Sales and Marketing departments connected via vNet peering.

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│              Company A                          │
├──────────────────────────┬──────────────────────┤
│      Sales Department    │ Marketing Department │
├──────────────────────────┼──────────────────────┤
│ vNET01: 10.0.0.0/16      │ vNET02: 10.1.0.0/16  │
│ Subnet01: 10.0.0.0/24    │ Subnet02: 10.1.0.0/24│
│ VM01: 10.0.0.4           │ VM02: 10.1.0.4       │
│                    ↔ vNET Peering ↔             │
└──────────────────────────┴──────────────────────┘
```

## Resources Deployed

### Sales Department (vNET01)
- **Virtual Network**: `vnet-companyA-dev-sales`
  - Address Space: 10.0.0.0/16
- **Subnet**: `subnet-companyA-dev-sales`
  - Address Range: 10.0.0.0/24
- **Network Security Group**: `nsg-companyA-dev-sales`
  - Allows RDP (3389)
  - Allows all vNet-to-vNet traffic
- **Network Interface**: `nic-companyA-dev-sales`
  - Private IP: 10.0.0.4
- **Virtual Machine**: `vm-companyA-dev-sales`
  - OS: Windows Server 2022
  - Size: Standard_B2s

### Marketing Department (vNET02)
- **Virtual Network**: `vnet-companyA-dev-marketing`
  - Address Space: 10.1.0.0/16
- **Subnet**: `subnet-companyA-dev-marketing`
  - Address Range: 10.1.0.0/24
- **Network Security Group**: `nsg-companyA-dev-marketing`
  - Allows RDP (3389)
  - Allows all vNet-to-vNet traffic
- **Network Interface**: `nic-companyA-dev-marketing`
  - Private IP: 10.1.0.4
- **Virtual Machine**: `vm-companyA-dev-marketing`
  - OS: Windows Server 2022
  - Size: Standard_B2s

### vNet Peering
- **Sales to Marketing**: `peer-companyA-dev-sales-to-marketing`
- **Marketing to Sales**: `peer-companyA-dev-marketing-to-sales`
- Both peerings allow:
  - Virtual Network Access
  - Forwarded Traffic

## Prerequisites

- Azure CLI or Azure PowerShell
- A resource group to deploy to
- Appropriate Azure permissions (Owner or Contributor role)

## Deployment

### Using Azure CLI

```bash
# Create resource group
az group create \
  --name companyA-dev-rg \
  --location eastus

# Deploy using bicepparam file
az deployment group create \
  --resource-group companyA-dev-rg \
  --template-file main.bicep \
  --parameters main.bicepparam
```

### Using Azure PowerShell

```powershell
# Create resource group
New-AzResourceGroup -Name 'companyA-dev-rg' -Location 'eastus'

# Deploy using bicepparam file
New-AzResourceGroupDeployment `
  -ResourceGroupName 'companyA-dev-rg' `
  -TemplateFile 'main.bicep' `
  -TemplateParameterFile 'main.bicepparam'
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `location` | string | `eastus` | Azure region for resource deployment |
| `environment` | string | `dev` | Environment name (dev, staging, prod) |
| `projectName` | string | `companyA` | Project name for resource naming |
| `deployVMs` | bool | `true` | Whether to deploy Virtual Machines |
| `vmAdminUsername` | string | `azureuser` | Admin username for VMs |
| `vmAdminPassword` | securestring | (required) | Admin password for VMs (must be 12+ chars) |

### Customizing Parameters

Edit `main.bicepparam` to customize parameters:

```bicepparam
param location = 'eastus'
param environment = 'prod'
param projectName = 'companyA'
param deployVMs = true
param vmAdminUsername = 'azureuser'
param vmAdminPassword = 'YourSecurePassword123!'
```

## Outputs

The template provides the following outputs:

- `salesVnetId`: Sales vNET resource ID
- `marketingVnetId`: Marketing vNET resource ID
- `salesSubnetId`: Sales subnet resource ID
- `marketingSubnetId`: Marketing subnet resource ID
- `salesVmIpAddress`: Sales VM private IP address (10.0.0.4)
- `marketingVmIpAddress`: Marketing VM private IP address (10.1.0.4)
- `salesToMarketingPeeringId`: Sales to Marketing peering resource ID
- `marketingToSalesPeeringId`: Marketing to Sales peering resource ID

## Security Considerations

1. **Network Security Groups**: 
   - RDP access is allowed from any source for demo purposes
   - In production, restrict RDP to specific IP ranges
   - Peering allows all vNet-to-vNet traffic

2. **Virtual Machine Credentials**:
   - Change the default admin username and password
   - Use strong passwords (minimum 12 characters)
   - Consider using Azure Key Vault for credential management

3. **Connectivity**:
   - After deployment, you can RDP into either VM
   - Use the private IPs to test connectivity between vNets

## Testing Connectivity

After deployment:

1. **RDP into Sales VM**: Use public IP (if available) or Azure Bastion
2. **Ping Marketing VM**: From Sales VM, ping 10.1.0.4
3. **Verify Peering**: Check peering status in Azure Portal

## Cost Estimation

- Virtual Networks: Free
- Subnets: Free
- Network Interfaces: Free
- NSGs: Free
- vNet Peering: Free (within region)
- VMs (if deployVMs=true): ~$40-60/month each (Standard_B2s)
- Storage (OS disks): ~$10-20/month each

**Total Estimated Monthly Cost**: $100-200 (with VMs)

## Cleanup

To remove all deployed resources:

```bash
az group delete --name companyA-dev-rg --yes
```

## Template Features

✅ **Best Practices**:
- Uses symbolic references instead of `resourceId()` functions
- Implements Network Security Groups for traffic control
- Configures static private IP addresses
- Uses bicepparam files for parameter management
- Comprehensive documentation and outputs

✅ **Flexibility**:
- Customize location, environment, and project name
- Optional VM deployment
- Easy parameter adjustment

✅ **Production-Ready**:
- Uses managed disks (Premium_LRS)
- Implements NSG rules for security
- Supports multiple environments
- Clear naming conventions

## Troubleshooting

### Deployment Fails with Authentication Error
- Ensure you're logged in: `az login`
- Verify permissions in the target resource group

### VMs Cannot Communicate
- Check NSG rules allow vNet-to-vNet traffic
- Verify peering status is "Connected"
- Test with `ping` command between VMs

### Parameter File Issues
- Ensure `main.bicepparam` is in the same directory as `main.bicep`
- Update the `using` directive path if needed

## References

- [Azure Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Virtual Network Peering](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview)
- [Network Security Groups](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)
- [Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/)
