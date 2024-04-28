resource appav_set 'Microsoft.Compute/availabilitySets@2020-12-01' = {
  name: 'apave-set'
  location: 'West Us'
  sku:{
    name: 'Aligned'
  }
  properties:{
    platformFaultDomainCount: 3
    platformUpdateDomainCount: 5
  }
}
