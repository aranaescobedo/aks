param location string
param name string

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: name
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowAnyCustom3443Inbound'
        properties: {
          direction: 'Inbound'
          priority: 100
          destinationPortRange: '3443'
          protocol: 'TCP'
          sourceAddressPrefix: 'ApiManagement.WestEurope' //TODO: TRY ONLY WITH ApiManagement
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
        }
      }
      {
        name: 'AllowAzureLoadBalancer6390Inbound'
        properties: {
          direction: 'Inbound'
          priority: 110
          destinationPortRange: '6390'
          protocol: 'TCP'
          sourceAddressPrefix: 'AzureLoadBalancer'
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
        }
      }
      // {
      //   name: 'AllowAppGatewayToAPIM'
      //   properties: {
      //     direction: 'Inbound'
      //     priority: 120
      //     destinationPortRange: '443'
      //     protocol: 'TCP'
      //     sourceAddressPrefix: 'AzureLoadBalancer' //TODO VNET PREFIX FROM AGIC VNET
      //     sourcePortRange: '*'
      //     destinationAddressPrefix: 'VirtualNetwork'
      //     access: 'Allow'
      //   }
      // }
    ]
  }
}

output id string = nsg.id
