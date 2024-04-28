resource app_ip 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: 'app-ip'
  location: 'East US'
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}
