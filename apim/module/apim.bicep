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
    publicIpAddressId: null //TODO: LOOKS LIKE YOU CANT'T DISABLE PUBLIC IP ON APIM? CHECK IT OUT?
  }
}

output gatewayURL string = apim.properties.gatewayUrl
output devPortalURL string = apim.properties.developerPortalUrl
output adminPortalURL string = apim.properties.managementApiUrl
