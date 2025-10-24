#############################################
# Module for conditional role assignments to
# constrain roles and principal types that
# can be assigned by a service principal.
#############################################

locals {
  # azurerm_role_definition.id returns a resource ID, but the condition expression needs only the GUID.
  role_ids        = [for role in data.azurerm_role_definition.allowed_roles : split("/", role.id)]
  role_guids      = join(", ", [for role_id in local.role_ids : role_id[length(role_id) - 1]])
  principal_types = join(", ", [for type in var.allowed_principal_types : "'${type}'"])
}

data "azurerm_role_definition" "allowed_roles" {
  for_each = toset(var.allowed_role_names)
  name     = each.key
}

resource "azurerm_role_assignment" "sp_service_bus_uac" {
  principal_id         = var.principal_object_id
  role_definition_name = var.role_definition_name
  scope                = var.scope
  condition            = <<-EOC
  (
    (
      !(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})
    )
    OR
    (
      @Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${local.role_guids}}
      AND
      @Request[Microsoft.Authorization/roleAssignments:PrincipalType] ForAnyOfAnyValues:StringEqualsIgnoreCase {${local.principal_types}}
    )
  )
  AND
  (
    (
      !(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})
    )
    OR
    (
      @Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${local.role_guids}}
      AND
      @Resource[Microsoft.Authorization/roleAssignments:PrincipalType] ForAnyOfAnyValues:StringEqualsIgnoreCase {${local.principal_types}}
    )
  )
  EOC
  condition_version    = "2.0"
  principal_type       = "ServicePrincipal"
}
