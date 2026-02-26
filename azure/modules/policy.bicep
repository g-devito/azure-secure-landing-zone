param rgLocation string
var managedDiskPolicyId string = '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'

resource managedDiskPolicy 'Microsoft.Authorization/policyAssignments@2024-05-01' = {
  name: 'audit-vm-managed-disk'
  location: rgLocation
  properties: {
    displayName: 'Audit VMs without managed disks'
    description: 'Monitora le VM che utilizzano ancora dischi unmanaged.'
    policyDefinitionId: managedDiskPolicyId
    nonComplianceMessages: [
      {
        message: 'La VM utilizza unmanged disks, cambiare a managed disks quanto prima'
      }
    ]
  }
}
