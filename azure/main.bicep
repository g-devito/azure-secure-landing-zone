param serverName string = 'voteradmin'
param dbAdminUsername string = 'db'
param rgLocation string = resourceGroup().location
param vmConfig object = {
  vm1: {
    name: 'contoso'
    skuName: 'Standard_D2alds_v6'
    storageAccountType: 'Standard_LRS'
  }
  vm2: {
    name: 'fabrikam'
    skuName: 'Standard_D2alds_v6'
    storageAccountType: 'Standard_LRS'
  }
}

module vnet 'modules/vnet.bicep' = {
  name: 'vnet-deploy'
  params: {
    rgLocation: rgLocation
  }
}

resource kv 'Microsoft.KeyVault/vaults@2025-05-01' existing = {
    name: 'keyvault-voting-app'
}

module dns 'modules/dns.bicep' = {
  name: 'dns-deploy'
  params: {
    vnetId: vnet.outputs.vnetId
  }
}

module db 'modules/db.bicep' = {
  name: 'db-deploy'
  params: {
    rgLocation: rgLocation
    adminPassword: kv.getSecret('dbPwd')
    adminUsername: dbAdminUsername
    dnsZoneId: dns.outputs.dnsZoneId
    serverName: serverName
    subnetId: vnet.outputs.dbSubnetId
  }
}

module vm 'modules/vm.bicep' = [for config in items(vmConfig): {
  params: {
    sku: config.value.skuName
    subnetId: vnet.outputs.vmSubnetId
    vmName: config.value.name
    rgLocation: rgLocation
    vmPwd: kv.getSecret('vmPwd')
  }
}]

module policies 'modules/policy.bicep' = {
  params: {
    rgLocation: rgLocation
  }
}
