var location='West US'

resource appav_set 'Microsoft.Compute/availabilitySets@2020-12-01' = {
  name: 'apave-set'
  location: 'West US'
  sku:{
    name: 'Aligned'
  }
  properties:{
    platformFaultDomainCount: 3
    platformUpdateDomainCount: 5
  }
}

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
      {
        name: 'Allow-HTTP'
        properties: {
          description: 'Allow HTTP'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
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
      dataDisks:[
        {
        name: 'data-disk'
        diskSizeGB:16
        createOption:'Empty'
        lun:0
       
      }]
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
    availabilitySet:{
      id: appav_set.id
    }
  }
}

//custom script
resource appvmconfig 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' ={
  parent: app_vm
  name: 'appvmconfig'
  location: location
  properties:{
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtention'
    
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings:{
      fileUris:[
        'https://bazeyanstorage00.blob.core.windows.net/custom-scripts/IIS.ps1?sp=r&st=2024-04-28T16:09:47Z&se=2024-04-29T00:09:47Z&spr=https&sv=2022-11-02&sr=b&sig=DUUFxPhg03NcIUfb6giW0rSHCIXbbeOMnhaZHSA58To%3D'
      ]
    }
    protectedSettings:{
      commandToExecutr: 'powershell -ExecutionPolicy Unrestricted -file IIS.ps1'
    }
  }

}



