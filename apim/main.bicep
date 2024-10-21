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
var subscriptionId = subscription().subscriptionId
var vm_name = 'vm-linux-test-we-01'
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

module agw_pip 'br/public:avm/res/network/public-ip-address:0.5.1' = {
  scope: rsg
  name: '${pip_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    name: pip_name
  }
}

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

module agw 'br/public:avm/res/network/application-gateway:0.1.0' = {
  scope: rsg
  name: '${agw_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    name: agw_name
    sku: 'Standard_v2'
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: vnet.outputs.subnetResourceIds[0]
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: agw_pip.outputs.resourceId
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'backendPool'
        properties: {}
      }
      {
        name: 'APIM-backend-pool'
        properties: {
          backendAddresses: [
            {
             fqdn: '${apim_name}.azure-api.net'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'httpSetting'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 20
        }
      }
    ]
    httpListeners: [
      {
        name: 'listener'
        properties: {
          frontendIPConfiguration: {
            //id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', agw_name, 'appGwPublicFrontendIp')
            id: resourceId(subscriptionId, rsg.name, 'Microsoft.Network/applicationGateways/frontendIPConfigurations', agw_name, 'appGwPublicFrontendIp')
          }
          frontendPort: {
            //id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', agw_name, 'port_80')
             id: resourceId(subscriptionId, rsg.name, 'Microsoft.Network/applicationGateways/frontendPorts', agw_name, 'port_80')
          }
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'routingRule'
        properties: {
          ruleType: 'Basic'
          priority: 1
          httpListener: {
            id: resourceId(subscriptionId, rsg.name,'Microsoft.Network/applicationGateways/httpListeners', agw_name, 'listener')
          }
          backendAddressPool: {
            id: resourceId(subscriptionId, rsg.name,'Microsoft.Network/applicationGateways/backendAddressPools', agw_name, 'backendPool')
          }
          backendHttpSettings: {
            id: resourceId(subscriptionId, rsg.name,'Microsoft.Network/applicationGateways/backendHttpSettingsCollection', agw_name, 'httpSetting')
          }
        }
      }
    ]
    autoscaleMinCapacity: 1
    autoscaleMaxCapacity: 2
  }
}

module vm 'br/public:avm/res/compute/virtual-machine:0.6.0' = {
  scope: rsg
  name: '${vm_name}-${substring(uniqueString(dateTime),0,4)}'
  params: {
    name: vm_name
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: '0001-com-ubuntu-server-jammy'
      publisher: 'Canonical'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            pipConfiguration: {
              name: 'pip-vm-test-we-01'
            }
            subnetResourceId: vnet.outputs.subnetResourceIds[2]
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      diskSizeGB: 100
      managedDisk: {
        storageAccountType: 'StandardSSD_LRS'
      }
    }
    osType: 'Linux'
    vmSize: 'Standard_DS2_v2'
    zone: 0
    adminPassword: 'Test1234!'
    encryptionAtHost: false //Recommended to be true, but because this is for test purpose it will be false.
  }
}
