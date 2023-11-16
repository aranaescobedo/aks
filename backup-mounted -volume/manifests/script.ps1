#I'm using Azure CLI in this example:
#$aksName = "aks-cluster-test-we-01"
$aksResourceGroup = "rg-cluster-test-we"
$backupVaultName = "bvault-volume-test-we-01"
$backupPolicyName = "bvault-policy-test-we-01"
$desName = "des-volume-test-we-01"
$email = "<YOUR_EMAIL>"
$kvResourceGroup = "rg-volume-test-we"
$kvName = "kv-volume-test-we-01"
$keyName = "key-cluster-volume-test-we-01"
$location = "westeurope"
$namespace = "hero"
$subscriptionName = <SUBSCRIPTION_NAME>
$userAssignedIdentity = "id-cluster-test-we-01"

"[*] Set subscription: $subscriptionName"
az account set --subscription $subscriptionName

"[*] Create resource group for the Key Vault"
az group create --name $kvResourceGroup --location $location

#Purge soft-deleted key vault (WARNING! THIS OPERATION WILL PERMANENTLY DELETE YOUR KEY VAULT)
#These commands below are used for testing purposes!
#az keyvault list-deleted --subscription $subscriptionName --resource-type vault
#az keyvault purge --subscription $subscriptionName --name $kvName

"[*] Create Key Vault"
$keyVaultId = az keyvault create `
              --name $kvName `
              --resource-group $kvResourceGroup `
              --enable-rbac-authorization true `
              --location $location `
              --enabled-for-disk-encryption true `
              --query "id" -o tsv `
              --enable-purge-protection false #This should be 'true' when used in real prod scenarios.

"[*] Give yourself the Key Vault Administrator permission"
az role assignment create `
    --assignee $email `
    --role "Key Vault Administrator" `
    --scope $keyVaultId

"[*] Create Key"
$keyUrl = az keyvault key create `
          --subscription $subscriptionName `
          --vault-name $kvName `
          --name $keyName `
          --kty RSA `
          --size 2048 `
          --query "key.kid" -o tsv

"[*] Create disk encryption set"
$diskEncryptionSetId = az disk-encryption-set create `
  --resource-group $kvResourceGroup `
  --name $desName `
  --key-url $keyUrl `
  --source-vault $kvName `
  --query "id" -o tsv

"[*] Get disk encryption set identity"
$principalId = az disk-encryption-set identity show `
              --name $desName `
              --resource-group $kvResourceGroup `
              --query "principalId" -o tsv

"[*] Give disk encyption set access to Key Vault"
az role assignment create `
  --assignee $principalId `
  --role "Key Vault Crypto Service Encryption User" `
  --scope $keyVaultId
  #--role "Key Vault Crypto User" `CHECK IF YOU ARE GIVING THE RIGHT ACCESS TO THE KEY VAULT..

#"[*] Create resource group for the AKS"
#az group create --name $aksResourceGroup --location $location

"[*] Create a AKS user assigned identity"
$clientId = az identity create `
    --name $userAssignedIdentity `
    --resource-group $aksResourceGroup `
    --query "clientId" -o tsv

"[*] Give AKS user assigned identity Read permission to disk encyption set"
az role assignment create `
    --assignee $clientId `
    --role "Reader" `
    --scope $diskEncryptionSetId

"[*] Create AKS"
#Attn: Encryption of OS disk with customer-managed keys can only be enabled when creating an AKS cluster!
#When creating the cluster you already get Azure Disks CSI driver enabled.
az aks create `
  --resource-group $kvResourceGroup `
  --name $aksName `
  --assign-identity $clientId `
  --kubernetes-version 1.26 `
  --node-count 1 `
  --location $location `
  --network-plugin azure `
  --node-osdisk-diskencryptionset-id $diskEncryptionSetId `
  --node-osdisk-type Managed

"[*] Update AKS with with disk driver"
#Not possible to run --enable-disk-driver with az aks create
az aks update `
  --resource-group $kvResourceGroup `
  --name $aksName `
  --enable-disk-driver

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

#SOURCE:
#https://learn.microsoft.com/en-us/azure/aks/csi-storage-drivers
#https://learn.microsoft.com/en-us/azure/aks/azure-disk-csi
#https://learn.microsoft.com/en-us/azure/backup/backup-managed-disks-cli
#https://learn.microsoft.com/en-us/azure/aks/azure-disk-customer-managed-keys
#https://github.com/openshift/azure-disk-csi-driver/blob/master/deploy/example/failover/README.md
