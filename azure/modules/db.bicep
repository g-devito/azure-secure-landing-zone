param serverName string
param adminUsername string
@secure()
param adminPassword string
param subnetId string
param dnsZoneId string
param rgLocation string

resource postgresServer 'Microsoft.DBforPostgreSQL/flexibleServers@2023-06-01-preview' = {
  name: serverName
  location: rgLocation
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
    version: '15'
    storage: {
      storageSizeGB: 32
    }
    network: {
      delegatedSubnetResourceId: subnetId
      privateDnsZoneArmResourceId: dnsZoneId
    }
  }
}

output serverFQDN string = postgresServer.properties.fullyQualifiedDomainName
