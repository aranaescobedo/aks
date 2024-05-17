targetScope = 'subscription'

param location string = deployment().location

@description('Used to get a random guid in the end of the deployment names')
param dateTime string = utcNow()

//VAR
var apimName = 'apim-demo-test-we-01'
var nsgName = 'nsg-demot-test-we-01'
var pipName = 'pip-agw-test-we-01'
var vnetName = 'vnet-test-we-01'

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

module agw_vnet 'module/vnet.bicep' = {
  scope: rsg
  name: '${vnetName}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    location: location
    nsgSourceId: nsg.outputs.id
    vnetAddressPrefix: '10.10.1.0/24'
    vnetName: vnetName
  }
}

module agw_pip 'module/pip.bicep' = {
  scope: rsg
  name:  '${pipName}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    location: location
    name: pipName
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


