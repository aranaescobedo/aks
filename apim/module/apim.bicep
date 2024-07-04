param location string
param name string
param snetResourceId string

resource apim 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: name
  location: location
  sku: {
    capacity: 1
    name: 'Developer'
  }
  properties: {
    publisherEmail: 'he.man@innovate-it.com'
    publisherName: 'He man'
    virtualNetworkType: 'Internal'
    virtualNetworkConfiguration: {
      subnetResourceId: snetResourceId
    }
    //Public IP addresses are used for internal communication on port 3443 - for managing configuration (for example, through Azure Resource Manager).
    //In the internal VNet configuration, public IP addresses are only used for Azure internal management operations and don't expose your instance to the internet.
    //https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-ip-addresses?WT.mc_id=Portal-Microsoft_Azure_ApiManagement#ip-addresses-of-api-management-service-in-vnet
    publicIpAddressId: null
  }
}

output gatewayURL string = apim.properties.gatewayUrl
output devPortalURL string = apim.properties.developerPortalUrl
output adminPortalURL string = apim.properties.managementApiUrl
