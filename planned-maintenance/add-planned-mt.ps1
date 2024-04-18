<#
    .DESCRIPTION
        XXXXX

    .NOTES
        AUTHOR: Alexander Arana E
        LASTEDIT: March XX, 2024
#>


param(
    [Parameter(Mandatory = $true)]
    [string]
    [ValidateSet("dev", "qa", "prod")]
    $environment,
    [Parameter(Mandatory = $true)]
    [string]
    $subscriptionName
)

$getRootDir = git rev-parse --show-toplevel
Set-Location "$getRootDir\planned-maintenance"

#Variables
$aksName = "aks-cluster-$($environment)-we-01"
$location = "west europe"
$resouceGroup = "rg-cluster-$($environment)-we"

#az login
az account set --subscription $subscriptionName
"[*] Set subscription $subscriptionName"

#Create resource group for the AKS:
az group create `
    --name $resouceGroup `
    --location $location

#Create AKS:
az aks create `
    --resource-group $resouceGroup `
    --name $aksName `
    --node-count 1 `
    --kubernetes-version 1.28.5 `
    --location $location `
    --auto-upgrade-channel stable

#Add Planned AKS upgrades.
az aks maintenanceconfiguration add `
    --resource-group $resouceGroup `
    --cluster-name $aksName `
    --name aksManagedAutoUpgradeSchedule `
    --config-file $environment-auto-upgrade-cluster-sched.json

#Add Planned node OS images upgrades.
az aks maintenanceconfiguration add `
    --resource-group $resouceGroup `
    --cluster-name $aksName `
    --name aksManagedNodeOSUpgradeSchedule `
    --config-file $environment-auto-upgrade-node-os-sched.json

#List maintenance configurations in the cluster.
az aks maintenanceconfiguration list `
      --resource-group $resouceGroup `
      --cluster-name $aksName

#Show the details of a maintenance configuration in the cluster.
az aks maintenanceconfiguration show `
     --resource-group $resouceGroup `
     --cluster-name $aksName `
     --name aksManagedAutoUpgradeSchedule

#Delete a maintenance configuration in the cluster.
az aks maintenanceconfiguration delete `
    --resource-group $resouceGroup `
    --cluster-name $aksName `
    --name aksManagedNodeOSUpgradeSchedule

