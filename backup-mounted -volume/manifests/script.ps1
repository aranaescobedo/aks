#I'm using Azure CLI in this example:
$aksName = "aks-cluster-test-we-01"
$aksResourceGroup = "rg-cluster-test-we"
$backupVaultName = "bvault-volume-test-we-01"
$backupPolicyName = "bvault-policy-test-we-01"
$kvResourceGroup = "rg-volume-test-we"
$kvName = "kv-volume-test-we-01"
$keyName "key-cluster-volume-test-we-01"
$location = "westeurope"
$namespace = "hero"
$subscriptionName = <SUBSCRIPTION_NAME>

"[*] Create resource group for the Key Vault"
az group create --name $kvResourceGroup --location $location

"[*] Create Key Vault"
az keyvault create --name $kvName --resource-group $kvResourceGroup --location $location

"[*] Create Key"
$xxx = az keyvault key create `
--subscription $subscriptionName `
--vault-name $kvName
--name $keyName `
--kty RSA `
--size 2048 `
//TODO: Enable oft delete and purge protection

"[*] Create disk encryption set"
$xxx = az disk-encryption-set create `
--resource-group MyResourceGroup `
--name MyDiskEncryptionSet `
--key-url MyKey `
--source-vault $kvName

"[*] Create resource group for the AKS"
az group create --name $aksResourceGroup --location $location

"[*] Create AKS"
//Encryption of OS disk with customer-managed keys can only be enabled when creating an AKS cluster. TRUE?
az aks create `
--resource-group $aksResourceGroup `
--name $aksName `
--kubernetes-version 1.26 `
--node-count 1 `
--location $location `
--enable-disk-driver `
--network-plugin azure `
--node-osdisk-diskencryptionset-id $diskEncryptionSetId `
--node-osdisk-type Managed

"[*] Create Backup Vault" 
az dataprotection backup-vault create `
--resource-group $kvResourceGroup `
--vault-name $backupVaultName `
--location $location `
--type SystemAssigned
--storage-settings datastore-type="VaultStore"type="LocallyRedundant"

"[*] Get policy template"
az dataprotection backup-policy get-default-policy-template --datasource-type AzureDisk > policy.json

"[*] Create Backup Policy"
az dataprotection backup-policy create --resource-group $kvResourceGroup --vault-name $backupVaultName `
--backup-policy-name  $backupPolicyName --policy policy.json

//SOURCE:
//https://learn.microsoft.com/en-us/azure/aks/csi-storage-drivers
//https://learn.microsoft.com/en-us/azure/aks/azure-disk-csi
//https://learn.microsoft.com/en-us/azure/backup/backup-managed-disks-cli
//https://learn.microsoft.com/en-us/azure/aks/azure-disk-customer-managed-keys
//https://github.com/openshift/azure-disk-csi-driver/blob/master/deploy/example/failover/README.md
