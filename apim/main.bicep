targetScope = 'subscription'

param location string = deployment().location

@description('Used to get a random guid in the end of the deployment names')
param dateTime string = utcNow()

//VAR
var agw_name = 'agw-test-we-01'
var apim_name = 'apim-test-we-01'
var apim_snet_ip_address = '10.10.1.64/26'
var nsg_name = 'nsg-apim-test-we-01'
var pip_name = 'pip-agw-test-we-01'
var vnet_name = 'vnet-test-we-01'

resource rsg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-apim-test-we'
  location: location
}

module nsg 'module/nsg.bicep' = {
  scope: rsg
  name: '${nsg_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    apimAddressPrefix: apim_snet_ip_address
    location: location
    name: nsg_name
  }
}

module vnet 'module/vnet.bicep' = {
  scope: rsg
  name: '${vnet_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    apimAddressPrefix: apim_snet_ip_address
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

module apim 'module/apim.bicep' = {
  scope: rsg
  name: '${apim_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    location: location
    name: apim_name
    snetResourceId: vnet.outputs.subnetIdForApim
  }
}

module agw 'module/agw.bicep' = {
  scope: rsg
  name: '${agw_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    apimGatewayURL: replace(apim.outputs.gatewayURL, 'https://', '')
    location: location
    name: agw_name
    pipId: agw_pip.outputs.id
    snetId: vnet.outputs.subnetIdForAgw
  }
}


