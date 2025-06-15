param location string
param virtualMachineName string
param virtualMachineComputerName string
param adminUsername string
@secure()
param adminPassword string

param vmSize string = 'Standard_DS1_v2'

param addressPrefix string = '10.0.0.0/16'
param subnetPrefix string = '10.0.0.0/24'
param subnetName string = 'default'

param nsgName string = '${virtualMachineName}-nsg'

param publicIpName string = '${virtualMachineName}-pip'
param publicIpAllocationMethod string = 'Dynamic'
param publicIpSku string = 'Basic'

param nicName string = '${virtualMachineName}-nic'

param osDiskStorageType string = 'Standard_LRS'
param osDiskSizeGiB int = 127

param imagePublisher string = 'MicrosoftWindowsServer'
param imageOffer string = 'WindowsServer'
param imageSku string = '2025-Datacenter-G2'
param imageVersion string = 'latest'

var vnetName = '${virtualMachineName}-vnet'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
        }
      }
    ]
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2020-05-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-RDP'
        properties: {
          priority: 300
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
    ]
  }
}

resource publicIpAddress 'Microsoft.Network/publicIpAddresses@2020-08-01' = {
  name: publicIpName
  location: location
  properties: {
    publicIPAllocationMethod: publicIpAllocationMethod
  }
  sku: {
    name: publicIpSku
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: virtualNetwork.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpAddress.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: virtualMachineName
  location: location
  properties: {
    priority: 'Spot' // Enables Spot VM pricing
    evictionPolicy: 'Deallocate' // or 'Delete' - what happens on eviction
    billingProfile: {
      maxPrice: -1 // -1 means pay up to the on-demand price; or specify max $/hour
    }
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskStorageType
        }
        diskSizeGB: osDiskSizeGiB
      }
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: imageVersion
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    osProfile: {
      computerName: virtualMachineComputerName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
      }
    }
  }
}

output adminUsername string = adminUsername
