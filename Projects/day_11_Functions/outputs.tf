output "rgname" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.rg.name
}

output "storage_name" {
  description = "Storage Account Name"
  value       = azurerm_storage_account.example.name
}

output "nsg_rules" {
  description = "Network Security Group Rules"
  value       = local.nsg_rules
}

output "security_name" {
  description = "Network Security Group Name"
  value       = azurerm_network_security_group.example.name
}