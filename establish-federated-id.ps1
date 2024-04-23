<#
    .DESCRIPTION
        This script is used to establish federated identity credential for a new application on the AKS cluster.
    .NOTES
        AUTHOR: Alexander Arana E
        LASTEDIT: March 23, 2024
#>

param(
    [Parameter(Mandatory = $true)]
    [string]
    [ValidateSet("test", "dev", "qa", "prod")]
    $env = "",
    [Parameter(Mandatory = $true)]
    [string]
    $namespace,
    [Parameter(Mandatory = $true)]
    [string]
    $subscriptionName
)

$getRootDir = git rev-parse --show-toplevel
Set-Location $getRootDir\aks

$aksName = "aks-cluster-${env}-we-01"
$aksResourceGroup = "rg-cluster-${env}-we"

#az login
az account set --subscription $subscriptionName
kubectl config use-context aks-cluster-$env-we-01

$idName = "id-contoso-${env}-we-01"
$idResourceGroup = "rg-contoso-${env}-we"
$federatedName = "fic-contoso-${env}-we-01"
$filePath = "workload-identity\${env}\contoso-serviceaccount.yaml"
$serviceAccountName = "contoso-workload-identity"

$clientId = (az identity show --name $idName --resource-group $idResourceGroup | ConvertFrom-Json).clientId

echo @"
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    azure.workload.identity/use: "true"
  name: $serviceAccountName
  namespace: $namespace
"@ > $filePath | kubectl apply -f $filePath

"[*] Get the OIDC Issuer URL"
$aks_oidc_issuer = "$(az aks show -n $aksName -g $aksResourceGroup --query "oidcIssuerProfile.issuerUrl" -otsv)"

"[*] Establish federated identity credential for ${idName}"
az identity federated-credential create --name $federatedName --identity-name $idName --resource-group $idResourceGroup --issuer $aks_oidc_issuer --subject system:serviceaccount:${namespace}:${serviceAccountName}
