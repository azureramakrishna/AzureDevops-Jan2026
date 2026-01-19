using './main.bicep'

param location = 'eastus'
param environment = 'dev'
param projectName = 'saanvikit'
param deployVMs = true
param vmAdminUsername = 'azureuser'
param vmAdminPassword = 'P@ssw0rd!2024Secure'

// Active Directory Domain Configuration
param joinDomain = true
param domainName = 'contoso.com'
param domainAdminUsername = 'domainadmin'
param domainAdminPassword = 'DomainP@ss123456'
param domainOuPath = 'OU=Servers,DC=contoso,DC=com'
param dnsServers = [
  '192.168.1.10'
  '192.168.1.11'
]
