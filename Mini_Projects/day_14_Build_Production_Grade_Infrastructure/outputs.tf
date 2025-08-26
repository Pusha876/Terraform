output "lb_public_ip" {
  description = "Load Balancer Public IP address"
  value       = azurerm_public_ip.lb_pip.ip_address
}

output "lb_public_fqdn" {
  description = "Load Balancer Public FQDN (if domain label is set)"
  value       = azurerm_public_ip.lb_pip.fqdn
}

output "nat_public_ip" {
  description = "NAT Gateway Public IP address (egress only)"
  value       = azurerm_public_ip.nat_gw_pip.ip_address
}

output "nat_public_fqdn" {
  description = "NAT Gateway Public FQDN (if domain label is set)"
  value       = azurerm_public_ip.nat_gw_pip.fqdn
}
