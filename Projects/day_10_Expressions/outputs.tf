output "security_rules" {
  description = "Flattened view of NSG security rules"
  value       = azurerm_network_security_group.example.security_rule
}

output "env" {
  description = "Selected environment"
  value       = var.environment
}

output "demo" {
  value = [ for count in local.nsg_rules : count.description ]
}

output "splat" {
  value = local.nsg_rules[*].allow_http.description_port_range
}