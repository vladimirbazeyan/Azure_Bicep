resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'qaqlanstorage'
  location: 'West US'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
