var location='West US'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'app-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'SubnetA'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: 'bastion-ip'
  location: location
  sku:{
      name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    
  }
}

resource app_bastion 'Microsoft.Network/bastionHosts@2020-07-01' = {
  name: 'app-bastion'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'bastion-config'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetwork.name, 'AzureBastionSubnet')
          }
          publicIPAddress: {
            id: publicIPAddress.id
          }
        }
      }
    ]
  }  
}
