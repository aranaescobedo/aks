$resourceGroupName = "rg-network-dev-we"
$vnetName = "vnet-cluster-dev-we-01"
$subnetName = "snet-cluster-dev-we-03"
$vmName = "vm-istio-dev-we-02"
$computerName = "vmistiodev02"
$subscriptionName  = "vaultit-dev"
 
#az login
az account set --n $subscriptionName
$subnetId =$(az network vnet subnet show --resource-group $resourceGroupName --name $subnetName --vnet-name $vnetName --query id -o tsv)
 
 
az vm create `
--resource-group $resourceGroupName  `
--name $vmName `
--computer-name $computerName `
--location westeurope  `
--image Win2022DataCenter `
--subnet $subnetId `
--admin-username "adminUser"  `
--admin-password "uUHqzb8KSAvDw9Cf" `
--size Standard_B2s `
--public-ip-sku "Standard" `
--public-ip-address '""'