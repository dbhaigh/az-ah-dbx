//partial backend configuration to prevent local state file creation while run from ADO. Ref. https://www.terraform.io/docs/language/settings/backends/configuration.html#partial-configuration
terraform {
  backend "azurerm" {}

  required_providers {

    azuread = {
      source = "hashicorp/azuread"
    }

    azurerm = {
      source = "hashicorp/azurerm"
    }

    databricks = {
      source = "databricks/databricks"
    }

    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}