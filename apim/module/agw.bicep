param location string


// resource applicationGateway 'Microsoft.Network/applicationGateways@2020-06-01' = {
//   name: applicationGatewayName
//   location: location
//   properties: {
//     sku: {
//       name: appGwSize
//       tier: 'WAF_v2'
//     }

//     autoscaleConfiguration: {
//       minCapacity: minCapacity
//       maxCapacity: maxCapacity
//     }
//     gatewayIPConfigurations: [
//       {
//         name: 'appGatewayIpConfig'
//         properties: {
//           subnet: {
//             id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetwork.name, subnetName)
//           }
//         }
//       }
//     ]
//     frontendIPConfigurations: [
//       {
//         name: 'appGatewayFrontendIP'
//         properties: {
//           publicIPAddress: {
//             id: publicIP.id
//           }
//         }
//       }
//     ]
//     frontendPorts: [
//       {
//         name: 'appGatewayFrontendPort'
//         properties: {
//           port: frontendPort
//         }
//       }
//       {
//         name: 'appGatewayFrontendPortHTTPS'
//         properties: {
//           port: frontendPortHTTPS
//         }
//       }
//     ]
//     backendAddressPools: [
//       {
//         name: 'appGatewayBackendPool'
//         properties: {
//           backendAddresses: backendIPAddresses
//         }
//       }
//     ]
//     backendHttpSettingsCollection: [
//       {
//         name: 'appGatewayBackendHttpSettings'
//         properties: {
//           port: backendPort
//           protocol: 'Http'
//           cookieBasedAffinity: cookieBasedAffinity
//         }
//       }
//     ]
//     httpListeners: [
//       {
//         name: 'appGatewayHttpListener'
//         properties: {
//           frontendIPConfiguration: {
//             id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', applicationGatewayName, 'appGatewayFrontendIP')
//           }
//           frontendPort: {
//             id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', applicationGatewayName, 'appGatewayFrontendPort')
//           }
//           protocol: 'Http'
//         }
//       }
//     ]
//     requestRoutingRules: [
//       {
//         name: 'rule1'
//         properties: {
//           ruleType: 'Basic'
//           httpListener: {
//             id: resourceId('Microsoft.Network/applicationGateways/httpListeners', applicationGatewayName, 'appGatewayHttpListener')
//           }
//           backendAddressPool: {
//             id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'appGatewayBackendPool')
//           }
//           backendHttpSettings: {
//             id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'appGatewayBackendHttpSettings')
//           }
//         }
//       }
//     ]
//   }
//   identity: {
//   type: 'UserAssigned'
//     userAssignedIdentities:{
//       '${useridentityId}':{}
//     }    
//   }
// }
