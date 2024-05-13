$getRootDir = git rev-parse --show-toplevel
Set-Location "$getRootDir\apim"

$subscriptioName = 'dev' #TODO: CREATE PLACEHOLDER INSTEAD

az account set -n $subscriptioName

az deployment sub create  --location westeurope --template-file main.bicep -c

az stack sub create  --location westeurope --template-file main.bicep -c