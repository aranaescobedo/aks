param location string
param nsgSourceId string
param subnetName string
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
        name: subnetName
        properties: {
          addressPrefix: vnetAddressPrefix
          networkSecurityGroup: {
            id: nsgSourceId
          }
        }
      }
    ]
    
  }
}

output id string = vnet.id
output name string = vnet.name
output subnetId string = vnet.properties.subnets[0].id
