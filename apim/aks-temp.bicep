
@description('Generated from /subscriptions/cdb1ebb2-b415-4f06-b967-0898633686eb/resourceGroups/rg-apim-test-we/providers/Microsoft.ContainerService/managedClusters/test-alex')
resource testalex 'Microsoft.ContainerService/managedClusters@2024-03-02-preview' = {
  location: 'westeurope'
  name: 'test-alex'
  kind: 'Base'
  properties: {
    provisioningState: 'Succeeded'
    powerState: {
      code: 'Running'
    }
    kubernetesVersion: '1.28.9'
    currentKubernetesVersion: '1.28.9'
    dnsPrefix: 'test-alex-dns'
    fqdn: 'test-alex-dns-klr0had3.hcp.westeurope.azmk8s.io'
    azurePortalFQDN: 'ed89ecbbef5495e5ec9269603dea969d-priv.portal.hcp.westeurope.azmk8s.io'
    privateFQDN: 'test-alex-dns-7s4a7lfb.fdffaae3-a645-4ac2-9be4-1b91a030b2b5.privatelink.westeurope.azmk8s.io'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        vmSize: 'Standard_D2s_v3'
        osDiskSizeGB: 128
        osDiskType: 'Managed'
        kubeletDiskType: 'OS'
        vnetSubnetID: '/subscriptions/cdb1ebb2-b415-4f06-b967-0898633686eb/resourceGroups/rg-apim-test-we/providers/Microsoft.Network/virtualNetworks/vnet-test-we-01/subnets/snet-cluster-test-we-01'
        maxPods: 30
        type: 'VirtualMachineScaleSets'
        enableAutoScaling: false
        provisioningState: 'Succeeded'
        powerState: {
          code: 'Running'
        }
        orchestratorVersion: '1.28.9'
        currentOrchestratorVersion: '1.28.9'
        enableNodePublicIP: false
        mode: 'System'
        osType: 'Linux'
        osSKU: 'Ubuntu'
        nodeImageVersion: 'AKSUbuntu-2204gen2containerd-202406.19.0'
        upgradeSettings: {
          maxSurge: '10%'
        }
        enableFIPS: false
        securityProfile: {
          sshAccess: 'LocalUser'
          enableVTPM: false
          enableSecureBoot: false
        }
        eTag: '608b2360-31b0-49dc-861e-e149d513e773'
      }
    ]
    windowsProfile: {
      adminUsername: 'azureuser'
      enableCSIProxy: true
    }
    servicePrincipalProfile: {
      clientId: 'msi'
    }
    addonProfiles: {
      azureKeyvaultSecretsProvider: {
        enabled: true
        config: {
          enableSecretRotation: 'false'
          rotationPollInterval: '2m'
        }
        identity: {
          resourceId: '/subscriptions/cdb1ebb2-b415-4f06-b967-0898633686eb/resourcegroups/test-alex-clusternodes/providers/Microsoft.ManagedIdentity/userAssignedIdentities/azurekeyvaultsecretsprovider-test-alex'
          clientId: '0658325c-9cab-4c55-af0f-d04265bd4d44'
          objectId: '79f55d6f-05bb-4ee1-9467-4d44b8162cd8'
        }
      }
      azurepolicy: {
        enabled: false
        config: null
      }
    }
    nodeResourceGroup: 'test-alex-clusternodes'
    enableRBAC: true
    supportPlan: 'KubernetesOfficial'
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'calico'
      networkDataplane: 'azure'
      loadBalancerSku: 'Standard'
      loadBalancerProfile: {
        managedOutboundIPs: {
          count: 1
        }
        effectiveOutboundIPs: [
          {
            id: '/subscriptions/cdb1ebb2-b415-4f06-b967-0898633686eb/resourceGroups/test-alex-clusternodes/providers/Microsoft.Network/publicIPAddresses/d04bddda-d416-4706-8f4e-4d3ecb5932c3'
          }
        ]
        backendPoolType: 'nodeIPConfiguration'
      }
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
      outboundType: 'loadBalancer'
      serviceCidrs: [
        '10.0.0.0/16'
      ]
      ipFamilies: [
        'IPv4'
      ]
    }
    aadProfile: {
      managed: true
      adminGroupObjectIDs: null
      adminUsers: null
      enableAzureRBAC: true
      tenantID: 'f5f36f7b-d575-4ded-ad90-9bb4668748e3'
    }
    maxAgentPools: 100
    privateLinkResources: [
      {
        id: '/subscriptions/cdb1ebb2-b415-4f06-b967-0898633686eb/resourcegroups/rg-apim-test-we/providers/Microsoft.ContainerService/managedClusters/test-alex/privateLinkResources/management'
        name: 'management'
        type: 'Microsoft.ContainerService/managedClusters/privateLinkResources'
        groupId: 'management'
        requiredMembers: [
          'management'
        ]
      }
    ]
    apiServerAccessProfile: {
      enablePrivateCluster: true
      privateDNSZone: 'system'
      enablePrivateClusterPublicFQDN: true
    }
    identityProfile: {
      kubeletidentity: {
        resourceId: '/subscriptions/cdb1ebb2-b415-4f06-b967-0898633686eb/resourcegroups/test-alex-clusternodes/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test-alex-agentpool'
        clientId: 'd9d75e8a-3ec8-4bac-84a6-f98c14f60022'
        objectId: 'dc229a0d-2817-4842-ad1d-175025f7a0a0'
      }
    }
    autoUpgradeProfile: {
      upgradeChannel: 'none'
      nodeOSUpgradeChannel: 'NodeImage'
    }
    disableLocalAccounts: true
    securityProfile: {}
    storageProfile: {
      diskCSIDriver: {
        enabled: true
        version: 'v1'
      }
      fileCSIDriver: {
        enabled: true
      }
      snapshotController: {
        enabled: true
      }
    }
    oidcIssuerProfile: {
      enabled: false
    }
    workloadAutoScalerProfile: {}
    metricsProfile: {
      costAnalysis: {
        enabled: false
      }
    }
    resourceUID: '668702cc370eaf00012c937b'
    controlPlanePluginProfiles: {
      'azure-monitor-metrics-ccp': {
        enableV2: true
      }
      karpenter: {
        enableV2: true
      }
      'live-patching-controller': {
        enableV2: true
      }
    }
    nodeProvisioningProfile: {
      mode: 'Manual'
    }
    bootstrapProfile: {
      artifactSource: 'Direct'
    }
  }
  identity: {
    type: 'SystemAssigned'
    principalId: '38f2e906-afb3-4365-8e60-34ca73f7974d'
    tenantId: 'f5f36f7b-d575-4ded-ad90-9bb4668748e3'
  }
  sku: {
    name: 'Base'
    tier: 'Free'
  }
  eTag: '78106fbb-41bb-41f4-ae60-3f6cd5efd08d'
}
