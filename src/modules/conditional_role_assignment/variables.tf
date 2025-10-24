variable "principal_object_id" {
  description = "The ID of the principal (user, group, or service principal) to assign the role to."
  type        = string
}

variable "role_definition_name" {
  description = "The name of the Role Definition to assign to the Principal"
  type        = string
}

variable "scope" {
  description = "The ID of the resource at which the role assignment applies."
  type        = string
}

variable "allowed_role_names" {
  description = "List of Azure role names allowed by the principal to assign."
  type        = list(string)
}

variable "allowed_principal_types" {
  description = "List principal types allowed to assign the roles to."
  type        = list(string)
  validation {
    condition     = alltrue([for type in var.allowed_principal_types : contains(["Group", "ServicePrincipal"], type)])
    error_message = "Each type in allowed_principal_types must be one of 'Group', or 'ServicePrincipal'."
  }
}
