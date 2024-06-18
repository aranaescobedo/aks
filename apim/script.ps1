$getRootDir = git rev-parse --show-toplevel
Set-Location "$getRootDir\apim"

$subscriptioName = 'dev' #TODO: CREATE PLACEHOLDER INSTEAD
az account set -n $subscriptioName

# Run the <deployment sub create> command to run the validation of the bicep file. You cant validate with  <stack sub create>.
az deployment sub create --location westeurope --template-file main.bicep  --what-if --what-if-exclude-change-types NoChange

az stack sub create --name 'apim-deploy' --location westeurope --template-file main.bicep --deny-settings-mode None --yes