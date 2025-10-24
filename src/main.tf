#############################################
# Entity Contributor group
#############################################
resource "azuread_group" "entity_contributor_group" {
  display_name            = var.service_bus_entities_contributor_group_name
  description             = "Data Sender and Receiver access to Service Bus messaging entities."
  owners                  = [var.service_principal_object_id]
  administrative_unit_ids = toset(var.service_bus_groups_administrative_units)
  security_enabled        = true
}

resource "azuread_group_member" "entity_contributor_group_membership_spoke_owners" {
  group_object_id  = azuread_group.entity_contributor_group.object_id
  member_object_id = var.owner_group_id
}

resource "azuread_group_member" "entity_contributor_group_membership_spoke_contributors" {
  group_object_id  = azuread_group.entity_contributor_group.object_id
  member_object_id = var.contributor_group_id
}

resource "azurerm_role_assignment" "entity_contributor_group_service_bus_namespace_sender" {
  principal_id         = azuread_group.entity_contributor_group.object_id
  role_definition_name = "Azure Service Bus Data Sender"
  scope                = var.service_bus_namespace_resource_id
}

resource "azurerm_role_assignment" "entity_contributor_group_service_bus_namespace_receiver" {
  principal_id         = azuread_group.entity_contributor_group.object_id
  role_definition_name = "Azure Service Bus Data Receiver"
  scope                = var.service_bus_namespace_resource_id
}

#############################################
# Reader group
#############################################
resource "azuread_group" "reader_group" {
  display_name            = var.service_bus_namespace_reader_group_name
  description             = "Reader access to the Service Bus Namespace."
  owners                  = [var.service_principal_object_id]
  administrative_unit_ids = toset(var.service_bus_groups_administrative_units)
  security_enabled        = true
}

resource "azuread_group_member" "reader_group_membership_spoke_readers" {
  group_object_id  = azuread_group.reader_group.object_id
  member_object_id = var.reader_group_id
}

resource "azuread_group_member" "reader_group_membership_entity_contributor_group" {
  group_object_id  = azuread_group.reader_group.object_id
  member_object_id = azuread_group.entity_contributor_group.object_id
}

resource "azurerm_role_assignment" "reader_group_service_bus_namespace_reader" {
  principal_id         = azuread_group.reader_group.object_id
  role_definition_name = azurerm_role_definition.service_bus_namespace_reader.name
  scope                = var.service_bus_namespace_resource_id
}

#############################################
# SPN role assignments
#############################################
resource "azurerm_role_assignment" "spn_service_bus_namespace_manager" {
  principal_id         = var.service_principal_object_id
  role_definition_name = var.service_bus_namespace_manager_group_name
  scope                = var.service_bus_namespace_resource_id
  depends_on           = [azurerm_role_definition.service_bus_namespace_manager]
}

module "spn_service_bus_namespace_conditional_uac" {
  source = "./modules/conditional_role_assignment"

  principal_object_id     = var.service_principal_object_id
  role_definition_name    = "User Access Administrator"
  scope                   = var.service_bus_namespace_resource_id
  allowed_role_names      = ["Azure Service Bus Data Sender", "Azure Service Bus Data Receiver"]
  allowed_principal_types = ["Group"]
}
