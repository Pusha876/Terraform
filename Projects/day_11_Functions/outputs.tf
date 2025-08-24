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

output "vm_size" {
  description = "The size of the Virtual Machine based on environment"
  value       = local.vm_size
}

output "backup" {
  description = "Backup setting"
  value       = var.backup_name
}

output "credential" {
  description = "Credential value"
  value       = var.credential
  sensitive   = true
}

output "name" {
  description = "Unique locations"
  value       = local.unique_locations
}

output "max_cost" {
  description = "Maximum positive monthly cost"
  value       = local.max_cost
}

output "positive_costs" {
  description = "List of positive monthly costs"
  value       = local.positive_costs
}

output "resource_tag_date" {
  description = "Tag date in DD-MM-YYYY format"
  value       = local.tag_date
}