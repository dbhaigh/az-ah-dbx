# 4. Outputs (CRITICAL: You need these for the next step)
output "client_id" {
  value     = azurerm_service_principal.sp.application_id
  sensitive = true
}

output "client_secret" {
  value     = azurerm_service_principal.sp.client_secret
  sensitive = true
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}