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
        name: 'SubnetB'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}
resource app_ip 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: 'app-ip'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}
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
            id: resourceId('Microsoft.Network/virtualNetworks/subnets','app-vnet','SubnetA')
          }
          publicIPAddress:{
            id: app_ip.id
          }
        }
      }
    ]
    networkSecurityGroup:{
      id: app_nsg.id
    }
  }
}

resource app_nsg 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'app-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-RDP'
        properties: {
          description: 'Allow RDP'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}


// We can referance existing resource by adding class EXISTING
resource bazeyankeyvault  'Microsoft.KeyVault/vaults@2019-09-01' existing= {
  name: 'bazeyankeyvault'
  scope:resourceGroup('dd3a2488-1a34-4741-b1ab-4527b955c565','Bicep1')
  
}


//call vm bicep file
module vm './13-vm.bicep' ={
  name: 'DeployVm'
  params:{
    adminusername: bazeyankeyvault.getSecret('adminuser')
    adminPassword:bazeyankeyvault.getSecret('vmpassword')
  }
}
