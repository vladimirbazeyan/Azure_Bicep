var location='East US'
resource app_interface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'app-interface'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets','app-vnet','Subnet1')
          }
          publicIPAddress:{
            id: resourceId('Microsoft.Network/publicIPAddresses','BICEP','app-ip')
          }
        }
      }
    ]
  }
}
