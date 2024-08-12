targetScope = 'subscription'

param location string = deployment().location

@description('Used to get a random guid in the end of the deployment names')
param dateTime string = utcNow()

//VAR
var agw_name = 'agw-test-we-01'
var apim_name = 'apim-test-we-01'
var apim_snet_ip_address = '10.10.1.32/27'
var nsg_name = 'nsg-apim-test-we-01'
var pip_name = 'pip-agw-test-we-01'
var vnet_name = 'vnet-test-we-01'

resource rsg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-apim-test-we'
  location: location
}

module nsg 'br/public:avm/res/network/network-security-group:0.4.0' =  {
  scope: rsg
  name: '${nsg_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    name: nsg_name
    location: location
    securityRules: [
      {
        name: 'AllowAnyCustom3443Inbound'
        properties: {
          direction: 'Inbound'
          priority: 100
          destinationPortRange: '3443'
          protocol: 'Tcp'
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
          protocol: 'Tcp'
          sourceAddressPrefix: 'AzureLoadBalancer'
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
        }
      }
      {
        name: 'AllowAppGatewayToAPIM'
        properties: {
          direction: 'Inbound'
          priority: 120
          destinationPortRange: '443'
          protocol: 'Tcp'
          sourceAddressPrefix: apim_snet_ip_address
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
        }
      }
      {
        name: 'AllowTagStorage443Outbound'
        properties: {
          direction: 'Outbound'
          priority: 120
          destinationPortRange: '443'
          protocol: 'Tcp'
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
          protocol: 'Tcp'
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
          protocol: 'Tcp'
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
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'AzureMonitor'
          access: 'Allow'
        }
      }
    ]
  }
}

// module nsg 'module/nsg.bicep' = {
//   scope: rsg
//   name: '${nsg_name}-${substring(uniqueString(dateTime),0,4)}'
//   params: {
//     apimAddressPrefix: apim_snet_ip_address
//     location: location
//     name: nsg_name
//   }
// }

module vnet 'br/public:avm/res/network/virtual-network:0.2.0' = {
  scope: rsg
  name: '${vnet_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    addressPrefixes: [
      '10.10.1.0/24'
    ]
    name: vnet_name
    subnets: [
      {
        name: 'snet-agw-test-we-01'
        addressPrefix: '10.10.1.0/27'

      }
      {
        name: 'snet-apim-test-we-01'
        addressPrefix: apim_snet_ip_address
        networkSecurityGroupResourceId: nsg.outputs.resourceId
      }
      {
        name: 'snet-vm-test-we-01'
        addressPrefix: '10.10.1.64/27'
      }
      {
        name: 'snet-cluster-test-we-01'
        addressPrefix: '10.10.1.128/26'
      }
    ]
  }
}

// module vnet 'module/vnet.bicep' = {
//   scope: rsg
//   name: '${vnet_name}-${substring(uniqueString(dateTime),0,4)}'
//   params: {
//     apimAddressPrefix: apim_snet_ip_address
//     location: location
//     nsgSourceId: nsg.outputs.resourceId
//     vnetAddressPrefix: '10.10.1.0/24'
//     vnetName: vnet_name
//   }
// }

module agw_pip 'br/public:avm/res/network/public-ip-address:0.5.1' = {
  scope: rsg
  name: '${pip_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    name: pip_name
  }
}


// module agw_pip 'module/pip.bicep' = {
//   scope: rsg
//   name:  '${pip_name}-${substring(uniqueString(dateTime),0,4)}'
//   params: {
//     location: location
//     name: pip_name
//   }
// }

//Public IP addresses are used for internal communication on port 3443 - for managing configuration (for example, through Azure Resource Manager).
//In the internal VNet configuration, public IP addresses are only used for Azure internal management operations and don't expose your instance to the internet.
//https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-ip-addresses?WT.mc_id=Portal-Microsoft_Azure_ApiManagement#ip-addresses-of-api-management-service-in-vnet
module apim 'br/public:avm/res/api-management/service:0.3.0' = {
  scope: rsg
  name: '${apim_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    name: apim_name
    publisherEmail: 'he.man@innovate-it.com'
    publisherName: 'He man'
    virtualNetworkType: 'Internal'
    subnetResourceId: vnet.outputs.subnetResourceIds[1]
    sku: 'Developer'
    skuCapacity: 1
  }
}

// module apim 'module/apim.bicep' = {
//   scope: rsg
//   name: '${apim_name}-${substring(uniqueString(dateTime),0,4)}'
//   params: {
//     location: location
//     name: apim_name
//     snetResourceId: vnet.outputs.subnetIdForApim
//   }
// }

//*** COMMENT OUT ***
// module agw 'module/agw.bicep' = {
//   scope: rsg
//   name: '${agw_name}-${substring(uniqueString(dateTime),0,4)}'
//   params: {
//     apimGatewayURL: replace(apim.outputs.gatewayURL, 'https://', '')
//     location: location
//     name: agw_name
//     pipId: agw_pip.outputs.id
//     snetId: vnet.outputs.subnetIdForAgw
//   }
// }


