resource "azurerm_resource_group" "rg" {
  name     = "rg-service-bus"
  location = "westeurope"
}

resource "azuread_application" "sp_app" {
  display_name = "sp_app"
}

resource "azuread_service_principal" "sp" {
  client_id = azuread_application.sp_app.client_id
}

resource "azuread_group" "owner_group" {
  display_name     = "Owner Group"
  security_enabled = true
}

resource "azuread_group" "contributor_group" {
  display_name     = "Contributor Group"
  security_enabled = true
}

resource "azuread_group" "reader_group" {
  display_name     = "Reader Group"
  security_enabled = true
}

resource "azurerm_servicebus_namespace" "namespace" {
  name                = "namespace"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
}

module "defaults" {
  source = "../../src"

  # global
  service_principal_object_id = azuread_service_principal.sp.object_id
  owner_group_id              = azuread_group.owner_group.object_id
  contributor_group_id        = azuread_group.contributor_group.object_id
  reader_group_id             = azuread_group.reader_group.object_id

  # service bus
  service_bus_namespace_resource_id           = azurerm_servicebus_namespace.namespace.id
  service_bus_namespace_manager_group_name    = "Service Bus Namespace Manager {spoke}"
  service_bus_namespace_reader_group_name     = "Service Bus Namespace Readers {spoke}"
  service_bus_entities_contributor_group_name = "Service Bus Entity Contributors {spoke}"
  service_bus_groups_administrative_units     = ["5e832162-6aa4-470b-b24d-cc0b1299a8ab"]
}
