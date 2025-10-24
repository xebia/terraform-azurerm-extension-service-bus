variable "service_bus_namespace_resource_id" {
  description = "The resource id of the Azure Service Bus Namespace."
  type        = string
}

variable "service_bus_namespace_manager_group_name" {
  description = "The name of the group to create with to manage Service Bus Namespace entities like queues, topics, and subscriptions."
  type        = string
}

variable "service_bus_entities_contributor_group_name" {
  description = "The name of the group to create with Contributor access to the Service Bus messaging entities."
  type        = string
}

variable "service_bus_namespace_reader_group_name" {
  description = "The name of the group to create with Reader access to the Service Bus Namespace."
  type        = string
}

variable "service_bus_groups_administrative_units" {
  description = "The list of administrative unit IDs the spoke Service Bus groups should belong to."
  type        = list(string)
  default     = []
}
