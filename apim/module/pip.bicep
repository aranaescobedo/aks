param location string
param name string

resource public_ip 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

output id string = public_ip.id
