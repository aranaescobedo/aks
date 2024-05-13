targetScope = 'subscription'

param location string = deployment().location

@description('Used to get a random guid in the end of the deployment names')
param dateTime string = utcNow()

//VAR
var apimName = 'apim-demo-test-we-01'
var nsgName = 'nsg-demot-test-we-01'

resource rsg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-demo-test-we'
  location: location
}

module nsg 'module/nsg.bicep' = {
  scope: rsg
  name: '${nsgName}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    location: location
    name: nsgName
  }
}

// module apim 'module/apim.bicep' = {
//   scope: rsg
//   name: '${apimName}-${substring(uniqueString(dateTime),0,4)}'
//   params: {
//     location: location
//     name: apimName
//     subneResoucetId: 
//   }
// }


