<#
    .DESCRIPTION
        This script is used to add the cost analysis add-on to an existing cluster.
        Ensure that your cluster is not running on the Free tier.
        See docs if you want to learn how to disable it or add the add-on to a new cluster.
        https://learn.microsoft.com/en-us/azure/aks/cost-analysis?wt.mc_id=searchAPI_azureportal_inproduct_rmskilling&sessionId=c9a872241c154e4a84ec273dfbc40cc0#enable-cost-analysis-on-your-aks-cluster
    .NOTES
        AUTHOR: Alexander Arana E
        LASTEDIT: Dec 02, 2023
#>

#Variables.
$clusterName = ""
$clusterResourceGroup = ""
$subscriptionName = ""

#If you need to update the extension version.
az extension update --name aks-preview

#Register the 'ClusterCostAnalysis' feature flag.
az feature register --namespace "Microsoft.ContainerService" --name "ClusterCostAnalysis"

#Verify that the 'ClusterCostAnalysis' feature flag is registered.
#Took me 10-15 minutes before it was done!
az feature show --namespace "Microsoft.ContainerService" --name "ClusterCostAnalysis"

#When the status reflects 'Registered', refresh the registration.
az provider register --namespace Microsoft.ContainerService

#Set the Azure CLI context to the specified subscription.
az account set --name $subscriptionName

#Enable cost analysis on the AKS cluster.
az aks update --name $clusterName --resource-group $clusterResourceGroup --enable-cost-analysis
