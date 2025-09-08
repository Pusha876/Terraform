output "service_principal_name" {
  description = "The name of the Service Principal"
  value       = azuread_service_principal.main.display_name
}

output "service_principal_object_id" {
  description = "The object ID of the Service Principal"
  value       = azuread_service_principal.main.object_id
}

output "service_principal_tenant_id" {
  description = "The tenant ID of the Service Principal"
  value       = azuread_service_principal.main.application_tenant_id
}

output "client_id" {
  description = "The client ID of the Service Principal"
  value       = azuread_application.main.client_id
}

output "client_secret" {
  description = "The client secret of the Service Principal"
  value       = azuread_service_principal_password.main.value
  sensitive   = true
}