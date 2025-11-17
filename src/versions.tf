terraform {
  required_version = ">=1.9.2"
  required_providers {
    azurerm = {
      configuration_aliases = [
        azurerm,
        azurerm.servicebus,
      ]
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.0.2"
    }
  }
}
