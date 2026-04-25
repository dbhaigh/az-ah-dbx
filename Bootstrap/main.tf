# 1. Create the Resource Group for Infrastructure
resource "azurerm_resource_group" "infra" {
  name     = "terraform-infra"
  location = var.location
}

# 2. Create the Storage Account for State
resource "azurerm_storage_account" "state" {
  name                     = "tfstate${replace(var.environment, "/", "")}"
  resource_group_name      = azurerm_resource_group.infra.name
  location                 = azurerm_resource_group.infra.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "state" {
  name                  = "terraform-state"
  storage_account_id  = azurerm_storage_account.state.id
  container_access_type = "private"
}

# 3. Create the Service Principal (Identity)
resource "azurerm_client_config" "current" {}

resource "azurerm_role_definition" "custom_contributor" {
  name        = "Terraform Custom Contributor"
  scope       = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  description = "Custom role for Terraform to manage resources"
  
  permissions {
    actions = [
      "*/read",
      "Microsoft.Network/*/read",
      "Microsoft.Network/*/write",
      "Microsoft.Compute/*/write",
      "Microsoft.Storage/*/write",
      "Microsoft.Resources/deployments/write",
      "Microsoft.Resources/subscriptions/resourceGroups/write"
    ]
    not_actions = []
  }

  assignable_scopes = ["/subscriptions/${data.azurerm_client_config.current.subscription_id}"]
}

# We use a built-in role for simplicity in bootstrap, 
# but in prod, use the resource above.
resource "azurerm_role_assignment" "sp_contributor" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_service_principal.sp.id
}

resource "azurerm_service_principal" "sp" {
  name         = "terraform-sp-${var.environment}"
  client_secret = var.sp_secret
}
