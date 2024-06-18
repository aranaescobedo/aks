param agwSubnetName string
param location string
param nsgSourceId string
param vnetAddressPrefix string
param vnetName string

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: agwSubnetName
        properties: {
          addressPrefix: '10.10.1.0/26'
        }
      }
      {
        name: 'snet-apim-test-we-01'
        properties: {
          addressPrefix: '10.10.1.64/26'
          networkSecurityGroup: {
            id: nsgSourceId
          }
        }
      }
      {
        name: 'snet-cluster-test-we-01'
        properties: {
          addressPrefix: '10.10.1.128/27'
        }
      }
      {
        name: 'snet-vm-test-we-01'
        properties: {
          addressPrefix: '10.10.1.160/27'
        }
      }
    ]
  }
}

output id string = vnet.id
output name string = vnet.name
output subnetIdForAgw string = vnet.properties.subnets[0].id
output subnetIdForApim string = vnet.properties.subnets[1].id
output subnetIdForAks string = vnet.properties.subnets[2].id
output subnetIdForVm string = vnet.properties.subnets[3].id
