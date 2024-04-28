var location='West us'
resource bazeyan_appPlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'baz-appPlan'
  location: location
  sku: {
    name: 'F1'
    capacity: 1
  }
}

resource bazeyan_webapp 'Microsoft.Web/sites@2021-01-15' = {
  name: 'bazeyanplan4433'
  location: location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
  }
  properties: {
    serverFarmId: bazeyan_appPlan.id
    siteConfig:{
      netFrameworkVersion:'v6.0'
    }
  }

}
