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
        name: 'AllowTagAzureLoadBalancer6390Inbound'
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
      {
        name: 'AllowTagStorage443Outbound'
        properties: {
          direction: 'Outbound'
          priority: 120
          destinationPortRange: '443'
          protocol: 'TCP'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'Storage'
          access: 'Allow'
        }
      }
      {
        name: 'AllowTagSql1433Outbound'
        properties: {
          direction: 'Outbound'
          priority: 130
          destinationPortRange: '1433'
          protocol: 'TCP'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'Sql'
          access: 'Allow'
        }
      }
      {
        name: 'AllowTagAzureKeyVaultOutbound'
        properties: {
          direction: 'Outbound'
          priority: 140
          destinationPortRange: '433'
          protocol: 'TCP'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'AzureKeyVault'
          access: 'Allow'
        }
      }
      {
        name: 'AllowTagAzureMonitorOutbound'
        properties: {
          direction: 'Outbound'
          priority: 150
          destinationPortRanges: [
            '1886' 
            '443'
          ]
          protocol: 'TCP'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'AzureMonitor'
          access: 'Allow'
        }
      }
    ]
  }
}

output id string = nsg.id
