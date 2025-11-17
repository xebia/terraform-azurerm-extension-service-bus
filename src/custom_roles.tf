resource "azurerm_role_definition" "service_bus_namespace_manager" {
  provider = azurerm.servicebus

  name        = var.service_bus_namespace_manager_group_name
  scope       = var.service_bus_namespace_resource_id
  description = "Custom role to manage Service Bus Namespace entities."
  permissions {
    actions = [
      "Microsoft.ServiceBus/namespaces/queues/*",
      "Microsoft.ServiceBus/namespaces/topics/*",
      "Microsoft.ServiceBus/namespaces/topics/subscriptions/*",
      "Microsoft.ServiceBus/namespaces/read"
    ]
    not_actions = []
  }
  assignable_scopes = [
    var.service_bus_namespace_resource_id
  ]
}

resource "azurerm_role_definition" "service_bus_namespace_reader" {
  provider = azurerm.servicebus

  name        = var.service_bus_namespace_reader_group_name
  scope       = var.service_bus_namespace_resource_id
  description = "Custom role for read-only access to Service Bus Namespace."
  permissions {
    actions = [
      "Microsoft.ServiceBus/namespaces/read"
    ]
    not_actions = []
  }
  assignable_scopes = [
    var.service_bus_namespace_resource_id
  ]
}
