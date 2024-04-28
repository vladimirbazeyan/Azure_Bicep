@secure()
param adminPassword string

@secure()
param adminusername string
var location='West US'
//storage for boot diagnostic
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'vmbootdiagbazeyan00'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
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
      adminUsername: adminusername
      adminPassword: adminPassword
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
          id: resourceId('Microsoft.Network/networkInterfaces','app-interface')
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri:  reference(resourceId('Microsoft.Storage/storageAccounts',toLower('vmbootdiagbazeyan00'))).primaryEndpoints.blob
      }
    }
  }
}
