param rgLocation string

resource lbIpAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: 'lbIpAddress'
  location: rgLocation
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
     publicIPAddressVersion: 'IPv4'
  }
}


resource loadBalancerExternal 'Microsoft.Network/loadBalancers@2025-05-01' = {
  name: 'lb'
  location: rgLocation
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'lbPublicIp'
        properties: {
          publicIPAddress: {
            id: lbIpAddress.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'LoadBalancerBackEndPool'
      }
    ]
    inboundNatRules: [
      {
        name: 'name'
        properties: {
          frontendIPConfiguration: {
            id: 'frontendIPConfiguration.id'
          }
          protocol: 'Tcp'
          frontendPort: 50001
          backendPort: 3389
          enableFloatingIP: false
        }
      }
    ]
    loadBalancingRules: [
      {
        name: 'lbBackendPool'
        properties: {
          frontendIPConfiguration: {
             id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'lb', 'lbPublicIp')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'lb', 'LoadBalancerBackEndPool')
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          enableTcpReset: true
          idleTimeoutInMinutes: 15
          loadDistribution: 'Default'
          disableOutboundSnat: true
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', 'lb', 'lbHealthProbe')
          }
        }
      }
    ]
    probes: [
      {
        name: 'lbHealthProbe'
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]
  }
}
