Connect-AzAccount -TenantId 459865f1-a8aa-450a-baec-8b47a9e5c904 -SubscriptionId 2e28c82c-17d7-4303-b27a-4141b3d4088f

New-AzResourceGroup -Name arm -Location eastus

New-AzResourceGroupDeployment -ResourceGroupName arm -TemplateFile ./main.bicep -TemplateParametersFile ./main.bicepparam -Verbose