# I'm using Azure CLI in this example:
$aksName = "aks-cluster-test-we-01"
$aksResourceGroup = "rg-cluster-test-we"
$location = "westeurope"
$namespace = "hero"

# Create resource group for the AKS:
az group create --name $aksResourceGroup --location $location

# Create AKS:
az aks create --resource-group $aksResourceGroup --name $aksName --node-count 1 --enable-disk-driver --network-plugin azure --kubernetes-version 1.26 --location $location

//SOURCE:
//https://learn.microsoft.com/en-us/azure/aks/csi-storage-drivers
//https://learn.microsoft.com/en-us/azure/aks/azure-disk-csi
