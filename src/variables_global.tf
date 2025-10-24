variable "service_principal_object_id" {
  description = "The ID of the service principal of the spoke."
  type        = string
}

variable "owner_group_id" {
  description = "The ID of the PIM Owner group of the spoke."
  type        = string
}

variable "contributor_group_id" {
  description = "The ID of the PIM Contributor group of the spoke."
  type        = string
}

variable "reader_group_id" {
  description = "The ID of the PIM Reader group of the spoke."
  type        = string
}
