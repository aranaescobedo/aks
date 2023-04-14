param(
    [Parameter(Mandatory = $true)]
    [string]
    $aksName,
    [Parameter(Mandatory = $true)]
    [string]
    $aksResourceGroup,
    [Parameter(Mandatory = $true)]
    [string]
    $aksVersion,
    [Parameter(Mandatory = $true)]
    [string]
    $aksVnetName,
    [Parameter(Mandatory = $true)]
    [string]
    $networkResourceGroup,
    [Parameter(Mandatory = $true)]
    [ValidateLength(1,12)] #Nodepool name can only contain at most 12 characters
    [string]
    $nodePoolName,
    [Parameter(Mandatory = $true)]
    [string]
    $subnetName,
    [Parameter(Mandatory = $true)]
    [string]
    $subscriptionName,
    [Parameter(Mandatory = $true)]
    [string]
    $vmSize,
    [Parameter(Mandatory = $true)]
    [int[]]
    [ValidateSet(1, 2, 3)]
    $zones
)

"[*] Setting subscription to $subscriptionName"
az account set --subscription $subscriptionName

"[*] Getting subnet id for $subnetName"
$subnetId = (az network vnet subnet show --resource-group $networkResourceGroup --vnet-name $aksVnetName --name $subnetName | ConvertFrom-Json).id

"[*] Creating node pool: $nodePoolName..."
az aks nodepool add `
    --resource-group $aksResourceGroup `
    --cluster-name $aksName `
    --name $nodePoolName `
    --enable-cluster-autoscaler `
    --node-count 1 `
    --min-count 1 `
    --max-count 2 `
    --kubernetes-version $aksVersion `
    --os-sku "Ubuntu" `
    --os-type "Linux" `
    --max-pods 30 `
    --mode "User" `
    --node-vm-size $vmSize `
    --vnet-subnet-id $subnetId `
    --zones $zones

$nodePoolStatus = (az aks nodepool show `
    --resource-group $aksResourceGroup `
    --cluster-name $aksName `
    --name $nodePoolName `
    --query 'provisioningState' `
    --output tsv)

"[*] Provisioning state: $nodePoolStatus"
