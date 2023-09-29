# I'm using Azure CLI in this example:
$aksName = "aks-cluster-test-we-01"
$aksResourceGroup = "rg-cluster-test-we"
$backupVaultName = "bvault-volume-test-we-01"
$kvResourceGroup = "rg-volume-test-we"
$kvName = "kv-volume-test-we-01"
"keyName" "key-cluster-volume-test-we-01"
$location = "westeurope"
$namespace = "hero"
$subscriptionName = <SUBSCRIPTION_NAME>

"[*] Create resource group for the AKS"
az group create --name $aksResourceGroup --location $location

"[*] Create AKS"
az aks create `
--resource-group $aksResourceGroup `
--name $aksName `
--kubernetes-version 1.26 `
--node-count 1 `
--location $location `
--enable-disk-driver `
--network-plugin azure

"[*] Create resource group for the Key Vault"
az group create --name $kvResourceGroup --location $location

"[*] Create Key Vault"
az keyvault create --name $kvName --resource-group $kvResourceGroup --location $location

"[*] Create Key"
az keyvault key create `
--subscription $subscriptionName `
--vault-name $kvName
--name $keyName `
--kty RSA `
--size 2048 `

"[*] Create disk encryption set"
az disk-encryption-set create `
--resource-group MyResourceGroup `
--name MyDiskEncryptionSet `
--key-url MyKey `
--source-vault MyVault

"[*] Create Backup Vault" 
az backup vault create --resource-group --name --location $location

//SOURCE:
//https://learn.microsoft.com/en-us/azure/aks/csi-storage-drivers
//https://learn.microsoft.com/en-us/azure/aks/azure-disk-csi
