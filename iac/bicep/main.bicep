// Scope
targetScope = 'subscription'

// Parameters
@description('Resource group where Microsoft Fabric capacity will be deployed. Resource group will be created if it doesnt exist')
param dprg string= 'rg-fabric'

@description('Microsoft Fabric Resource group location')
param rglocation string = 'canadacentral'

//@description('Email of Fabric Capacity Administrator')
//param fabric_capacity_admin_email string

@description('Cost Centre tag that will be applied to all resources in this deployment')
param cost_centre_tag string = 'MCAPS'

@description('System Owner tag that will be applied to all resources in this deployment')
param owner_tag string = 'anibal.um@hotmail.com'
//param owner_tag string = 'admin@anibalumhotmail.onmicrosoft.com'

@description('Subject Matter Expert (SME) tag that will be applied to all resources in this deployment')
param sme_tag string ='anibal.um@hotmail.com'
//param sme_tag string ='admin@anibalumhotmail.onmicrosoft.com'

@description('Timestamp that will be appendedto the deployment name')
param deployment_suffix string = utcNow()

// Variables
var fabric_deployment_name = 'fabric_dataplatform_deployment_${deployment_suffix}'
var keyvault_deployment_name = 'keyvault_deployment_${deployment_suffix}'

// Create data platform resource group
resource fabric_rg  'Microsoft.Resources/resourceGroups@2024-03-01' = {
 name: dprg 
 location: rglocation
 tags: {
        CostCentre: cost_centre_tag
        Owner: owner_tag
        SME: sme_tag
  }
}

// Deploy Key Vault with default access policies using module
module kv './modules/keyvault.bicep' = {
  name: keyvault_deployment_name
  scope: fabric_rg
  params:{
     location: fabric_rg.location
     keyvault_name: 'ba-kv01'
     cost_centre_tag: cost_centre_tag
     owner_tag: owner_tag
     sme_tag: sme_tag
  }
}

//Deploy Microsoft Fabric Capacity
//module fabric_capacity './modules/fabric-capacity.bicep' = {
//  name: fabric_deployment_name
//  scope: fabric_rg
//  params:{
//    fabric_name: 'bafabric01'
//    location: fabric_rg.location
//    cost_centre_tag: cost_centre_tag
//    owner_tag: owner_tag
//    sme_tag: sme_tag
//    adminUsers: fabric_capacity_admin_email
//    skuName: 'F2' // Default Fabric Capacity SKU F2
//  }
//}
