targetScope = 'subscription'

// PARAMETERS
param policySource string = 'globalbao/azure-policy-as-code'
param policyCategory string = 'Custom'
param assignmentEnforcementMode string = 'Default'

param listOfAllowedLocations array = [
  'eastus'
  'eastus2'
  'westus'
  'westus2'
]

param listOfAllowedSKUs array = [
  'Standard_B1ls'
  'Standard_B1ms'
  'Standard_B1s'
  'Standard_B2ms'
  'Standard_B2s'
  'Standard_B4ms'
  'Standard_B4s'
  'Standard_D2s_v3'
  'Standard_D4s_v3'
]

// VARIABLES
var policyInitiativeName = 'PolicyInitiative1'
var policyAssignmentName = 'PolicyAssignment1'

// OUTPUTS
output policyInitiativeID string = policyInitiative.id
output policyAssignmentID string = policyAssignment.id

// RESOURCES

resource policyInitiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: policyInitiativeName
  properties: {
    policyType: 'Custom'
    displayName: policyInitiativeName
    description: '${policyInitiativeName} via ${policySource}'
    metadata: {
      category: policyCategory
      source: policySource
      version: '0.1.0'
    }
    parameters: {
      allowedLocations: {
        type: 'Array'
        metadata: ({
          description: 'The List of Allowed Locations for Resource Groups and Resources.'
          strongtype: 'location'
          displayName: 'Allowed Locations'
        })
      }
      allowedSKUs: {
        type: 'Array'
        metadata: any({
          description: 'The List of Allowed SKUs for Virtual Machines.'
          strongtype: 'vmSKUs'
          displayName: 'Allowed Virtual Machine Size SKUs'
        })
      }
    }
    policyDefinitions: [
      {
        //Allowed locations for resource groups
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988'
        parameters: {
          allowedLocations: {
            value: '[parameters(\'allowedLocations\')]'
          }
        }
      }
      {
        //Allowed locations
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
        parameters: {
          allowedLocations: {
            value: '[parameters(\'allowedLocations\')]'
          }
        }
      }
      {
        //Allowed virtual machine size SKUs
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3'
        parameters: {
          allowedSKUs: {
            value: '[parameters(\'allowedSKUs\')]'
          }
        }
      }
      {
        //Audit virtual machines without disaster recovery configured
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/0015ea4d-51ff-4ce3-8d8c-f3f8f0179a56'
        parameters: {}
      }
    ]
  }
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: policyAssignmentName
  properties: {
    displayName: policyAssignmentName
    description: '${policyAssignmentName} via ${policySource}'
    enforcementMode: assignmentEnforcementMode
    metadata: {
      source: policySource
      version: '0.1.0'
    }
    policyDefinitionId: policyInitiative.id
    parameters: {
      allowedLocations: {
        value: listOfAllowedLocations
      }
      allowedSKUs: {
        value: listOfAllowedSKUs
      }
    }
  }
}
