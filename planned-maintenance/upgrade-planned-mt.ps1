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
Set-Location "$getRootDir\scripts\aks\planned-maintenance"

$clusterName = "aks-cluster-$($environment)-we-01"
$resouceGroup = "rg-cluster-$($environment)-we"

#az login
az account set --subscription $subscriptionNam
"[*] Set subscription $subscriptionName"

az aks update --resource-group $resouceGroup --name $clusterName --auto-upgrade-channel stable

#Planned cluster upgrades
az aks maintenanceconfiguration update `
    --resource-group $resouceGroup `
    --cluster-name $clusterName `
    --name aksManagedAutoUpgradeSchedule `
    --config-file $environment-cluster-auto-upgrades.json

#Planned node OS images upgrades
# az aks maintenanceconfiguration update `
#     --resource-group $resouceGroup `
#     --cluster-name $clusterName `
#     --name aksManagedNodeOSUpgradeSchedule `
#     --config-file os-auto-upgrades.json

# az aks maintenanceconfiguration list `
#      --resource-group $resouceGroup `
#      --cluster-name $clusterName

#az aks maintenanceconfiguration show `
#     --resource-group $resouceGroup `
#     --cluster-name $clusterName `
#     --name "<NAME>"

 #az aks maintenanceconfiguration delete `
 #        --resource-group $resouceGroup `
 #        --cluster-name $clusterName `
 #        --name "<NAME>"
