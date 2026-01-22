Azure Admin & AzureDevops with AI
=================================

Duration: 2 to 3 months
Timings: 8am - 9am IST (Mon - Fri)

Daily recordings
Documentation
Labs
Project
Resume preperation
Interview questions
Certificate preperation

AZ-104
AZ-400


QA:
==

Azure Admin 
    - RBAC
    - Networking 
    - VM / VMSS
    - Storage 
    - AppServices
    - LoadBalancer
    - Security
        Keyvault
        RBAC
        Encryption
        Defender
    - Microsoft Entra ID (AAD)
    - Azure Monitor & Application Insight

AzureDevops:
    - IAC
        ARMTempaltes - JSON
        Bicep
        Terraform 
    - Azure Boards (Agile)
    - Azure Repo (Git & GitHub)
    - Azure Pipelines (CI CD) - YAML
    - GitHub Actions CI CD - YAML
    - Docker 
    - ACI, ACR, AKS 



Cloud Computing: 

Cloud computing service models:
    - IAAS
    - PAAS
    - SAAS

Cloud deployment models:
    - Public cloud
    - Private cloud 
    - Hybrid cloud

Azure 
Windows Azure - 2010
Microsoft Azure - 2014 

AZ-104
AZ-400 


Agenda:
======
1. Azure free trail account / Portal DEMO

    ** NEW EMAIL
       NEW MOBILE
       NEW CC/DC

       portal.azure.com
       
2. Azure services - categories


3. Azure pricing 


abc.com - datacenter 
Migrate to azure 


1 windows vm
1 linux vm
1 storage 
1 sql db 
1 loadbalancer 
1 security 

Azure pricing calculator:
========================



Agenda:
======
1. Azure RBAC (Role based access control) 

    - Owner             Grant full access to manage resources, ability to assign azure RBAC
    - Contributor       Grant full access to manage resources, but do not have ability to assign azure RBAC
    - Reader            view only access

    azureramakrishna@gmail.com - Owner

2. Azure Tags

    Subscription - Enterprise shared subscription

    Project = BMW
    Project = Mercedes
    Project = TATA


3. Azure Policies 


Agenda:
======
1. Azure Heirarchy 

    Management group
        \_
            Subscriptions
                \_
                    ResourceGroups
                        \_
                            Resources 


2. Basic network concept 

IP address (Internet protocal)

IPv4    32bit       0.0.0.0     255.255.255.255
IPv6    128bit


0.0.0.0     255.255.255.255


Class A     0.0.0.0         127.255.255.255
            10.0.0.0 to 10.255.255.255

Class B     128.0.0.0       191.255.255.255
            172.16.0.0 to 172.31.255.255

Class C     192.0.0.0       223.255.255.255
            192.168.0.0 to 192.168.255.255

Class D     224.0.0.0       239.255.255.255

Class E     240.0.0.0       255.255.255.255


CIDR:
====

10.0.0.0/16     = 2^32-16 = 2^16  = 65536 (5 reserved IPs) = 65531
10.0.0.0/24     = 2^32-24 = 2^8   = 256 = 251
192.168.0.0/25  =                 = 128 = 123
10.0.0.0/27     =                 = 32  = 27
10.0.0.0/29     =                 = 8   = 3
10.0.0.0/30     =                 = 4  



10.0.0.0/29 = 8


10.0.0.0    Network address.
10.0.0.1    Reserved by Azure for the default gateway.
10.0.0.2    Reserved by Azure to map the Azure DNS IP addresses to the virtual network space.
10.0.0.3    Reserved by Azure to map the Azure DNS IP addresses to the virtual network space.
10.0.0.4
10.0.0.5
10.0.0.6
10.0.0.7    Network broadcast address.


Azure Virtual Network (VNET):
============================

10.0.0.0/25

10.0.0.0 - 10.0.0.127

10.0.0.0
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.127


Azure Virtual Machine:
=====================

Server --> VM

windows - 127 GB
linux - 30GB


Azure windows VM --> IIS (Internet information services) --> sample html application --> IAAS 

    c:\\inetpub\wwwroot\iis.htm

Azure linux VM   --> Apache2 server                       --> sample html application --> IAAS
    /var/www/html/index.html


Availability set:   
================
    Fault domain:   1 - 3
    Update domain:  1 - 20


Availability zone:
=================


    100 VM already created - AV Set or AZ ?

    It is not possible

    VM --> snapshot --> NEW VM 



username & password 

common user and password: service account (service principal)


Azure VM --> Azure monitor (MMA)


Azure VM --> prometheus --> nex


2010 - windows azure        ASM (Azure service manager)
2014 - microsoft azure      ARM (Azure Resource Manager)

How many ways we can create resources:

1. Azure portal 
2. Azure powershell

        Login-AzAccount / Connect-AzAccount -TenantId xxxxxxxx -SubscriptionId xxxxxxxxxx
        Logout-AzAccount / Disconnect-AzAccount 

        Get-AzSubscription 
        Get-AzResourceGroup -Name saanvikit-rg

        New-AzResourceGroup -Name arm -Location Eastus

        Remove-AzResourceGroup -Name arm -Force 


3. Azure CLI 
        az login --teant
        az logout

        az account list 

        az group list
        az group create --name sainvikit-rg --location eastus
        az group delete -n sainvikit-rg -y


IAC:
4. ARM templates - JSON
5. Bicep
6. Terraform


  

Azure Storage Accounts:
======================

Azure storage account types:
===========================
1. Standard general-purpose v2      Blob Storage (including Data Lake Storage1), Queue Storage, Table Storage, and Azure Files  
2. Premium block blob               Blob Storage (including Data Lake Storage1)
3. Premium file share               Azure Files
4. Premium page blob                Page blobs only


Azure storage service types:
===========================
1. Blob - Binary large object
    - Page blob.   VHD
    - Append blob  logs
    - Block blob   unstructured data (image, pdf, word, audio, video etc)

2. Azure Fileshare
    Network file share 

3. Azure Queues
4. Azure Table

Azure Storage redundancy:
========================
1. LRS - Locally redundant storage      3 copies in primary region
2. ZRS - Zone redundant storage         3 copies in primay region with each copy in to each AZ
3. GRS - Geo redundant storage          6 copies, 3 in primary and 3 in secondary region. you will not have access to seconday region
4. RA-GRS - Read access geo redundant storage   6 copies, 3 in primary and 3 in secondary region. read access to seconday region data
5. GZRS - Geo zone redundant storage    6 copies, 3 in primary with ZRS, 3 in secondary in LRS. you will not have access to seconday region
6. RA-GZRS - Read access geo zone redundant storage     6 copies, 3 in primary with ZRS, 3 in secondary in LRS. read access to seconday region data

Performance ties:
================
1. Standard - HDD
2. Premium  - SSD

Access tiers: pricing
============
1. Hot  
2. Cool 
3. Cold tier    
4. Archive  
5. Smart tier 

Hot tier - An online tier optimized for storing data that is accessed or modified frequently. The hot tier has the highest storage costs, but the lowest access costs.
Cool tier - An online tier optimized for storing data that is infrequently accessed or modified. Data in the cool tier should be stored for a minimum of 30 days. The cool tier has lower storage costs and higher access costs compared to the hot tier.
Cold tier - An online tier optimized for storing data that is rarely accessed or modified, but still requires fast retrieval. Data in the cold tier should be stored for a minimum of 90 days. The cold tier has lower storage costs and higher access costs compared to the cool tier.
Archive tier - An offline tier optimized for storing data that is rarely accessed, and that has flexible latency requirements, on the order of hours. Data in the archive tier should be stored for a minimum of 180 days.
Smart tier - Smart tier automatically moves your data between the hot, cool, and cold access tiers based on usage patterns, optimizing your costs for these access tiers automatically. To learn more, see Optimize costs with smart tier.


Storage Account endpoints:
=========================

Storage                         service	Endpoint
=======                         ================
Blob Storage	                https://<storage-account>.blob.core.windows.net
Static website (Blob Storage)	https://<storage-account>.web.core.windows.net
Azure Data Lake Storage	        https://<storage-account>.dfs.core.windows.net (ADLS) Heirarical Namespace
Azure Files	                    https://<storage-account>.file.core.windows.net
Queue Storage	                https://<storage-account>.queue.core.windows.net
Table Storage	                https://<storage-account>.table.core.windows.net


Lifecycle Management:  Blob
====================
Use Azure Storage lifecycle management policies to automatically transition blobs between tiers or delete them based on rules you define.


Static website on the storage account:
===========================


Azure Virtual Netowork connectivities:
=====================================
1. Virtual Network Peering 
    - Regional VNET Peering (VNET1 & VNET2 are in same region)
    - Global VNET Peering   (VNET1 - EastUS & VNET2 - UKSouth)

    **** Pre- requisite
    Both VNETs should not have any overlapping address spaces

    VNET01 = 10.0.0.0/24    10.0.0.0 to 10.0.0.255
    VNET02 = 10.0.1.0/24    10.0.1.0 to 10.0.1.255

2. Site to Site VPN:
   ================
    1. Create a Virtual Network
    2. Create a GatewaySubnet
    3. Create a VPNGateway and attach it to VNET

    4. Create a Local network gateway to represent onprem site

    5. Go to connections service
    6. Choose the connection type as Site-to-Site-VPN
    7. Under settings page Choose azure vpn and local network gateway
    8. Pass the sharedkey
    9. Choose the IKEV2
    10. Submit 

    11. Download the connection configuration and share it with the onprem network team.

3. Express Route:
   =============
    

4. Point to Site VPN:
   =================
    - Create a VirtualNetwork
    - Create a GatewaySubnet 
    - Create VPNGateway and attach it to VNET 

    - on the client machine generate the Root and Client certificates
    - Export the certificates

    - Go to the VPNGateway
    - Under setting click on the point-to-site-configuration
    - Provide the client machine IP range and choose authentiation as certificate based and provide certificate data
    
    - Download the VPN Configuration on client machine
    - Install and connect to VPN


Network Security group: NSG
======================
- Subnet
- Network interface (NIC)

RDP - 3389
SSH - 22
HTTP - 80
HTTPS - 443
SMB - 445



Microsoft Entra ID (Formarly called Azure Active directory):
===========================================================

Active directory: Identity and access management

Windows server --> ADDS (Active directory domain services) --> Active directory admin console


Microsoft Entra ID: Cloud managed, identity and access management 


- SSO (Single sign-on)
- MFA (Multi factor authentication)
- Conditional access (PAM)
- SSPR 
- RBAC 


Agenda:
======
1. App registration (Service Principal)
    Application (client) ID: dde5a4cb-a622-4b4a-a283-49a208a868e4
    Secret: mrc8Q~xN9UcWBmuq4zkrj8ZboPnxpGLGamQ4pdoG

    Directory (tenant) ID : 459865f1-a8aa-450a-baec-8b47a9e5c904

    az login --service-principal --username dde5a4cb-a622-4b4a-a283-49a208a868e4 --password mrc8Q~xN9UcWBmuq4zkrj8ZboPnxpGLGamQ4pdoG --tenant 459865f1-a8aa-450a-baec-8b47a9e5c904

2. Azure Keyvault (Secrets, Keys and certificates)

3. Managed Identities 



az keyvault secret show \
  --vault-name saanvikit \
  --name win-vm-password \
  --query value -o tsv

App Services:
============
1. Web Apps  --> PAAS

    Azure VM's - (Windows or Linux) - Weberver (IIS or Apache2) - Application --> IAAS

2. Logic Apps
3. Function Apps (Lamda AWS)



ai-tutorails.com
   
   |

https://saanvikit1.azurewebsites.net/ (CNAME)


Loadbalancers:
=============
1. Azure Load balancer (Network LB)
    - Types: Public and Private LB
    - Backend Pool: VM and VMSS
    - OSI Layer 4 (Transport layer)
    - Accept only HTTP / HTTPS

2. Application Gateway (Application LB)
    - Types: Small, Medium and Large
    - OSI Layer 7
    - Accept HTTP / HTTPS
    - Bakcked Pool: 
        - VM
        - VMSS
        - App services 
        - IP address / FQDN (Fully qualified domain name) ex: google.com/saanvikit.com
    - WAF (Web application firewall) protection from cyber threats
    - Path based routing
    - Multi site hosting
    - SSL Offfloading
    - Session affinity and redirection


3. Traffic Manager - DNS Based loadbalancer 

    The following traffic routing methods are available in Traffic Manager:

Priority: Select Priority routing when you want to use a primary service endpoint for all traffic. You can provide multiple backup endpoints in case the primary endpoint or one of the backup endpoints is unavailable.
Weighted: Select Weighted routing when you want to distribute traffic across a set of endpoints based on their weight. Set the weight the same to distribute evenly across all endpoints.
Performance: Select Performance routing when you have endpoints in different geographic locations and you want users to use the closest endpoint for the lowest network latency.
Geographic: Select Geographic routing to direct users to specific endpoints (Azure, External, or Nested) based on the geographic location of their DNS queries. This routing method helps you comply with scenarios such as data sovereignty mandates, localization of content and user experience, and measuring traffic from different regions.
Multivalue: Select MultiValue for Traffic Manager profiles that can only have IPv4/IPv6 addresses as endpoints. When this profile receives a query, it returns all healthy endpoints.
Subnet: Select Subnet traffic-routing method to map sets of user IP address ranges to a specific endpoint. When Traffic Manager receives a request, it returns the endpoint mapped to that request's source IP address.


4. Azure Front Door 
    Application Gateway + Traffic Manager profile + CDN



VMSS (Virtual Machine scale set): Horizental scaling

Azure Monitor & Alerts: Azure Monitor
======================


Azure SQL DB:
============
1. Azure SQL Database - PAAS 
2. Azure SQL Database Hyperscale - PAAS 
3. Azure SQL Managed Instance - PAAS
4. SQL on Azure VM - IAAS 


Sevice endpoint     
Subnet Delegation   
Private endpoint


AzureDevops :
===========
IAC - Infrastrcutre as a code

ARMTemplates (Azure Resource Manager templates) - JSON


Terraform:
=========

ARMTemplates                            Bicep                               Terraform
============                            =====                               ==========
1. IAC                                  1. IAC                              1. IAC
2. Specific to Azure                    2. Specific to Azure                2. Open source (Azure, AWS, GCP, onprem, etc)
3. JSON format                          3. Diclarative language             3. HCL format (Hashicorp configuration language)
4. template.json                        4. main.bicep                       4. main.tf
    parameters.json                         main.bicepparam                     variables.tf
5. Schema                               5. param                            5. building block
    contentversion                          var                                 provider
    parameters                              resources                           resources
    variables                               outputs                             outputs
    resources
    outputs
6. New-AzResourceGroupDeployment `                                          6. Lifecycle
    -ResourceGroupName arm                                                      terraform init
    -TemplateFile ./template.json                                               terraform fmt
    -TemplateParametersFile ./paramertes.json                                   terraform validate
    -Verbose                                                                    terraform plan
                                                                                terraform apply 
                                                                                terraform destroy


