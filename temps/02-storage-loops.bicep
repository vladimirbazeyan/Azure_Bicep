resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = [for i in range(0,3):  {
  name: '${i}qaqlanstorage'
  location: 'West US'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}]
