
resource data_disk 'Microsoft.Compute/disks@2023-04-02' = { 
  name: 'data-disk'
  location: 'West US'
  sku: {
    name: 'Standard_LRS'
  }
  properties:{
    creationData:{
      createOption: 'Empty'
    }
    diskSizeGB: 16
  }
}
