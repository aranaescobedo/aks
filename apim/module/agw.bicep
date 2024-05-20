param location string
param name string
param pipId string
param snetId string


resource agw_test 'Microsoft.Network/applicationGateways@2023-11-01' = {
  name: name
  location: location
  properties: {
    autoscaleConfiguration: {
      minCapacity: 1
      maxCapacity: 2
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: snetId
            //id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'vnet-test-we-01', 'snet-agw-test-we-01')
          }
        }
      }
    ]
    sku: {
      name: 'WAF_v2'
      tier: 'WAF_v2'
    }
  }
}

// resource agw 'Microsoft.Network/applicationGateways@2023-11-01' = {
//   name: name
//   location: location
//   properties: {
//     sku: {
//       name: 'WAF_v2'
//       tier: 'WAF_v2'
//     }

//     autoscaleConfiguration: {
//       minCapacity: 1
//       maxCapacity: 2
//     }
//     gatewayIPConfigurations: [
//       {
//         name: 'appGatewayIpConfig'
//         properties: {
//           subnet: {
//             // id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetwork.name, subnetName)
//             id: snetId
//           }
//         }
//       }
//     ]
//     frontendIPConfigurations: [
//       {
//         name: 'appGatewayFrontendIP'
//         properties: {
//           publicIPAddress: {
//             id: pipId
//           }
//         }
//       }
//     ]
//     // frontendPorts: [
//     //   {
//     //     name: 'appGatewayFrontendPort'
//     //     properties: {
//     //       port: frontendPort
//     //     }
//     //   }
//     //   {
//     //     name: 'appGatewayFrontendPortHTTPS'
//     //     properties: {
//     //       port: frontendPortHTTPS
//     //     }
//     //   }
//     // ]
//     // backendAddressPools: [
//     //   {
//     //     name: 'appGatewayBackendPool'
//     //     properties: {
//     //       backendAddresses: backendIPAddresses
//     //     }
//     //   }
//     // ]
//     // backendHttpSettingsCollection: [
//     //   {
//     //     name: 'appGatewayBackendHttpSettings'
//     //     properties: {
//     //       port: backendPort
//     //       protocol: 'Http'
//     //       cookieBasedAffinity: cookieBasedAffinity
//     //     }
//     //   }
//     // ]
//     // httpListeners: [
//     //   {
//     //     name: 'appGatewayHttpListener'
//     //     properties: {
//     //       frontendIPConfiguration: {
//     //         id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', applicationGatewayName, 'appGatewayFrontendIP')
//     //       }
//     //       frontendPort: {
//     //         id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', applicationGatewayName, 'appGatewayFrontendPort')
//     //       }
//     //       protocol: 'Http'
//     //     }
//     //   }
//     // ]
//     // requestRoutingRules: [
//     //   {
//     //     name: 'rule1'
//     //     properties: {
//     //       ruleType: 'Basic'
//     //       httpListener: {
//     //         id: resourceId('Microsoft.Network/applicationGateways/httpListeners', applicationGatewayName, 'appGatewayHttpListener')
//     //       }
//     //       backendAddressPool: {
//     //         id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'appGatewayBackendPool')
//     //       }
//     //       backendHttpSettings: {
//     //         id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'appGatewayBackendHttpSettings')
//     //       }
//     //     }
//     //   }
//     // ]
//   }
//   // identity: {
//   // type: 'UserAssigned'
//   //   userAssignedIdentities:{
//   //     '${useridentityId}':{}
//   //   }    
//   // }
// }
