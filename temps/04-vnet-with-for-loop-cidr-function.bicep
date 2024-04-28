resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'app-vnet'
  location: 'West US'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [ for i in range(1,3):{
        name: 'Subnet${i}'
        properties: {
          addressPrefix: cidrSubnet('10.0.0.0/16',24,i)
        }
      }
    ]
  }
}
