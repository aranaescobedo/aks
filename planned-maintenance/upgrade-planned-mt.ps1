<#
    .DESCRIPTION
        This script is used to update scheduled planned maintenance on your cluster, enabling both AKS and Node OS upgrades.

    .NOTES
        AUTHOR: Alexander Arana E
        LASTEDIT: March 23, 2024
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
$resouceGroup = "rg-cluster-$($environment)-we"

#az login
az account set --subscription $subscriptionName
"[*] Set subscription $subscriptionName"

az aks update `
--resource-group $resouceGroup `
--name $aksName `
--auto-upgrade-channel stable

#Add planned AKS upgrades.
az aks maintenanceconfiguration add `
    --resource-group $resouceGroup `
    --cluster-name $aksName `
    --name aksManagedAutoUpgradeSchedule `
    --config-file $environment-auto-upgrade-cluster-sched.json

#Update Planned AKS upgrades.
az aks maintenanceconfiguration update `
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

#Planned node OS images upgrades.
az aks maintenanceconfiguration update `
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
