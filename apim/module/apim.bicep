param location string
param name string
param subneResoucetId string

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
      subnetResourceId: subneResoucetId
    }
  }
}
