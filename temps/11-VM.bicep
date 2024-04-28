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
//storage for boot diagnostic
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'vmbootdiagbazeyan00'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
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

//VM
resource app_vm 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: 'app-vm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_Ds2_v2'
    }
    osProfile: {
      computerName: 'app-vm'
      adminUsername: 'appuser'
      adminPassword: 'Azure@123'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: 'windowsVM1ODisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: app_interface.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri:  reference(resourceId('Microsoft.Storage/storageAccounts/',toLower('vmbootdiagbazeyan00'))).primaryEndpoints.blob
      }
    }
  }
}
