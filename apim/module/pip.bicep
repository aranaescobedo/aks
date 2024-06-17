param location string = 'westeurope'
param name string = 'pip-agw-test-we-01'

resource public_ip 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

output id string = public_ip.id
