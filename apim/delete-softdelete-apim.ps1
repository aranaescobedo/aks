#https://learn.microsoft.com/en-us/azure/deployment-environments/how-to-authenticate
#https://learn.microsoft.com/en-us/azure/api-management/soft-delete

az login

$subscriptionName = 'dev' #TODO: CREATE PLACEHOLDER INSTEAD
az account set -n $subscriptionName

az account get-access-token

#GET SOFT DELETED APIMS
#GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ApiManagement/locations/{location}/deletedservices/{serviceName}?api-version=2021-08-01
GET https://management.azure.com/subscriptions/cdb1ebb2-b415-4f06-b967-0898633686eb/providers/Microsoft.ApiManagement/deletedservices?api-version=2021-08-01

#DELETE SOFT DELETED APIMS
#DELETE https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ApiManagement/locations/{location}/deletedservices/{serviceName}?api-version=2021-08-01
DELETE https://management.azure.com/subscriptions/cdb1ebb2-b415-4f06-b967-0898633686eb/providers/Microsoft.ApiManagement/locations/westeurope/deletedservices/apim-test-we-01?api-version=2021-08-01
