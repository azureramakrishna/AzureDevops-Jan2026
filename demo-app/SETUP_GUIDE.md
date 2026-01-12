# Azure Application Gateway Path-Based Routing Demo

## Overview
This demo application showcases Azure Application Gateway's path-based routing capabilities with two distinct backend services:
- **API Path** (`/api/*`) - Product catalog backend service
- **Images Path** (`/images/*`) - Static content delivery service

## Application Structure

```
demo-app/
├── index.html              # Main landing page
├── api/
│   └── products.html      # API backend service page
└── images/
    └── gallery.html       # Static content service page
```

## Setup Instructions

### Option 1: Quick Test with Python HTTP Server

1. **Navigate to the application directory:**
   ```bash
   cd /path/to/demo-app
   ```

2. **Start a simple HTTP server:**
   ```bash
   # Python 3
   python3 -m http.server 8080
   
   # Or Python 2
   python -m SimpleHTTPServer 8080
   ```

3. **Access the application:**
   - Open browser to: `http://localhost:8080`
   - Test paths:
     - Homepage: `http://localhost:8080/`
     - API path: `http://localhost:8080/api/products.html`
     - Images path: `http://localhost:8080/images/gallery.html`

### Option 2: Deploy to Azure VMs

#### Step 1: Create Two Backend VMs

**VM 1 - API Backend (api-vm):**
```bash
# Create resource group (if not exists)
az group create --name rg-appgw-demo --location eastus

# Create VM for API backend
az vm create \
  --resource-group rg-appgw-demo \
  --name api-vm \
  --image Ubuntu2204 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --size Standard_B2s
```

**VM 2 - Images Backend (images-vm):**
```bash
# Create VM for Images backend
az vm create \
  --resource-group rg-appgw-demo \
  --name images-vm \
  --image Ubuntu2204 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --size Standard_B2s
```

#### Step 2: Install Web Server on Each VM

**On both VMs, SSH in and run:**
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

#### Step 3: Deploy Application Files

**On API VM (api-vm):**
```bash
# Copy the files to the VM
scp -r demo-app/* azureuser@<api-vm-ip>:~/

# SSH into VM
ssh azureuser@<api-vm-ip>

# Deploy to Nginx
sudo cp ~/index.html /var/www/html/
sudo cp -r ~/api /var/www/html/

# Configure Nginx for API path
sudo tee /etc/nginx/sites-available/api-backend > /dev/null <<EOF
server {
    listen 80;
    server_name _;
    
    location / {
        root /var/www/html;
        index index.html;
    }
    
    location /api {
        root /var/www/html;
        index products.html;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/api-backend /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

**On Images VM (images-vm):**
```bash
# Copy the files to the VM
scp -r demo-app/* azureuser@<images-vm-ip>:~/

# SSH into VM
ssh azureuser@<images-vm-ip>

# Deploy to Nginx
sudo cp ~/index.html /var/www/html/
sudo cp -r ~/images /var/www/html/

# Configure Nginx for images path
sudo tee /etc/nginx/sites-available/images-backend > /dev/null <<EOF
server {
    listen 80;
    server_name _;
    
    location / {
        root /var/www/html;
        index index.html;
    }
    
    location /images {
        root /var/www/html;
        index gallery.html;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/images-backend /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

#### Step 4: Open Firewall Ports
```bash
# Allow HTTP traffic on both VMs
az vm open-port --resource-group rg-appgw-demo --name api-vm --port 80
az vm open-port --resource-group rg-appgw-demo --name images-vm --port 80
```

### Option 3: Azure Application Gateway Configuration

#### Step 1: Create Virtual Network
```bash
az network vnet create \
  --resource-group rg-appgw-demo \
  --name vnet-appgw \
  --address-prefix 10.0.0.0/16 \
  --subnet-name subnet-appgw \
  --subnet-prefix 10.0.1.0/24
```

#### Step 2: Create Public IP
```bash
az network public-ip create \
  --resource-group rg-appgw-demo \
  --name pip-appgw \
  --sku Standard \
  --allocation-method Static
```

#### Step 3: Create Application Gateway
```bash
az network application-gateway create \
  --resource-group rg-appgw-demo \
  --name appgw-demo \
  --location eastus \
  --vnet-name vnet-appgw \
  --subnet subnet-appgw \
  --public-ip-address pip-appgw \
  --http-settings-cookie-based-affinity Disabled \
  --sku Standard_v2 \
  --capacity 2
```

#### Step 4: Create Backend Pools

**API Backend Pool:**
```bash
az network application-gateway address-pool create \
  --resource-group rg-appgw-demo \
  --gateway-name appgw-demo \
  --name api-backend-pool \
  --servers <api-vm-private-ip>
```

**Images Backend Pool:**
```bash
az network application-gateway address-pool create \
  --resource-group rg-appgw-demo \
  --gateway-name appgw-demo \
  --name images-backend-pool \
  --servers <images-vm-private-ip>
```

#### Step 5: Configure Path-Based Routing

**Create URL Path Map:**
```bash
az network application-gateway url-path-map create \
  --resource-group rg-appgw-demo \
  --gateway-name appgw-demo \
  --name path-routing-map \
  --paths /api/* \
  --address-pool api-backend-pool \
  --default-address-pool api-backend-pool \
  --http-settings appGatewayBackendHttpSettings
```

**Add Images Path Rule:**
```bash
az network application-gateway url-path-map rule create \
  --resource-group rg-appgw-demo \
  --gateway-name appgw-demo \
  --path-map-name path-routing-map \
  --name images-rule \
  --paths /images/* \
  --address-pool images-backend-pool \
  --http-settings appGatewayBackendHttpSettings
```

**Update Listener to Use Path Map:**
```bash
az network application-gateway http-listener update \
  --resource-group rg-appgw-demo \
  --gateway-name appgw-demo \
  --name appGatewayHttpListener \
  --frontend-port 80

az network application-gateway rule update \
  --resource-group rg-appgw-demo \
  --gateway-name appgw-demo \
  --name rule1 \
  --url-path-map path-routing-map
```

## Demo Walkthrough

### 1. Access the Landing Page
- Navigate to: `http://<appgw-public-ip>/`
- Shows the main demo page with links to both paths

### 2. Test API Path Routing
- Click "Products API" or navigate to: `http://<appgw-public-ip>/api/products`
- This routes to the **api-backend-pool**
- Shows a dark-themed API interface with product listings
- Displays server information showing it's served from api-vm

### 3. Test Images Path Routing
- Click "Image Gallery" or navigate to: `http://<appgw-public-ip>/images/gallery`
- This routes to the **images-backend-pool**
- Shows a colorful gallery interface for static content
- Displays server information showing it's served from images-vm

### 4. Key Demo Points to Highlight

**Path-Based Routing:**
- `/api/*` → API Backend Pool (api-vm)
- `/images/*` → Images Backend Pool (images-vm)
- Different visual themes help distinguish the backends

**Server Information:**
- Each page displays the server hostname
- Demonstrates which backend pool is serving the request

**Use Cases:**
- API calls go to application servers
- Static content goes to optimized CDN/static servers
- Different scaling and caching strategies per path

## Testing Commands

```bash
# Get Application Gateway public IP
az network public-ip show \
  --resource-group rg-appgw-demo \
  --name pip-appgw \
  --query ipAddress \
  --output tsv

# Test API path
curl http://<appgw-public-ip>/api/products.html

# Test Images path
curl http://<appgw-public-ip>/images/gallery.html

# Test with path patterns
curl -I http://<appgw-public-ip>/api/products
curl -I http://<appgw-public-ip>/images/assets/logo.png
```

## Architecture Diagram

```
                                    ┌─────────────────────┐
                                    │   Internet User     │
                                    └──────────┬──────────┘
                                               │
                                               ▼
                                    ┌─────────────────────┐
                                    │  Application Gateway│
                                    │  (Public IP)        │
                                    └──────────┬──────────┘
                                               │
                        ┌──────────────────────┴──────────────────────┐
                        │     Path-Based Routing Rules                │
                        │                                              │
            ┌───────────▼──────────┐                   ┌──────────────▼────────┐
            │    /api/*            │                   │    /images/*          │
            │  API Backend Pool    │                   │  Images Backend Pool  │
            └───────────┬──────────┘                   └──────────────┬────────┘
                        │                                              │
                        ▼                                              ▼
            ┌───────────────────────┐                   ┌─────────────────────┐
            │    API VM             │                   │    Images VM        │
            │  (Nginx + API App)    │                   │  (Nginx + Gallery)  │
            │  10.0.1.4             │                   │  10.0.1.5           │
            └───────────────────────┘                   └─────────────────────┘
```

## Troubleshooting

### Check Backend Health
```bash
az network application-gateway show-backend-health \
  --resource-group rg-appgw-demo \
  --name appgw-demo
```

### View Application Gateway Logs
```bash
# Enable diagnostics
az monitor diagnostic-settings create \
  --resource $(az network application-gateway show \
    --resource-group rg-appgw-demo \
    --name appgw-demo \
    --query id -o tsv) \
  --name appgw-diagnostics \
  --logs '[{"category": "ApplicationGatewayAccessLog", "enabled": true}]' \
  --workspace <log-analytics-workspace-id>
```

### Common Issues

1. **502 Bad Gateway**
   - Check backend VMs are running
   - Verify NSG rules allow traffic from AppGW subnet
   - Check Nginx is running: `sudo systemctl status nginx`

2. **Path not routing correctly**
   - Verify URL path map configuration
   - Check path patterns include wildcard: `/api/*`
   - Ensure backend pools have correct VM IPs

3. **Page not loading**
   - Check HTML files are in correct directories
   - Verify Nginx configuration
   - Test backend directly: `curl http://<vm-ip>/api/products.html`

## Cleanup

```bash
# Delete the resource group (removes all resources)
az group delete --name rg-appgw-demo --yes --no-wait
```

## Additional Notes

- The application uses modern HTML5 and CSS3
- No external dependencies required (self-contained)
- Responsive design works on mobile and desktop
- Each path has distinct visual styling for easy identification
- Server hostname displayed on each page for verification

## Next Steps

1. Add SSL/TLS certificate for HTTPS
2. Configure custom health probes
3. Enable Web Application Firewall (WAF)
4. Add autoscaling for backend pools
5. Integrate with Azure Monitor for detailed analytics
