output "resource_group_name" {
    value = azurerm_resource_group.example.name
    description = "The name of the resource group"
}

output "storage_account_names" {
  value       = [for i in azurerm_storage_account.example: i.name]
    description = "List of storage account names created"
}