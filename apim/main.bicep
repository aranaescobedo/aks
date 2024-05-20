targetScope = 'subscription'

param location string = deployment().location

@description('Used to get a random guid in the end of the deployment names')
param dateTime string = utcNow()

//VAR
var agw_name = 'agw-test-we-01'
var agw_snet_name = 'snet-agw-test-we-01'
var apim_name = 'apim-test-we-01'
var nsg_name = 'nsg-demo-test-we-01'
var pip_name = 'pip-agw-test-we-01'
var vnet_name = 'vnet-test-we-01'

resource rsg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-demo-test-we'
  location: location
}

module nsg 'module/nsg.bicep' = {
  scope: rsg
  name: '${nsg_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    location: location
    name: nsg_name
  }
}

module agw_vnet 'module/vnet.bicep' = {
  scope: rsg
  name: '${vnet_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    agwSubnetName: agw_snet_name
    location: location
    nsgSourceId: nsg.outputs.id
    vnetAddressPrefix: '10.10.1.0/24'
    vnetName: vnet_name
  }
}

module agw_pip 'module/pip.bicep' = {
  scope: rsg
  name:  '${pip_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    location: location
    name: pip_name
  }
}

resource agw_subnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' existing = {
  scope: rsg
  name: agw_snet_name
}

module agw 'module/agw.bicep' = {
  scope: rsg
  name: '${agw_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    location: location
    name: agw_name
    pipId: agw_pip.outputs.id
    snetId: agw_subnet.id
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


