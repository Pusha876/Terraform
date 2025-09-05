# Resource Group
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.prov-rg.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.prov-rg.location
}

# Virtual Machine
output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.prov-vm.name
}

output "vm_private_ip" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_network_interface.main.private_ip_address
}

output "vm_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = azurerm_public_ip.main.ip_address
}

# SSH Connection Info
output "ssh_connection_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh -i ~/.ssh/id_rsa adminuser@${azurerm_public_ip.main.ip_address}"
}

# Nginx Server Access
output "nginx_server_url" {
  description = "URL to access the Nginx server"
  value       = "http://${azurerm_public_ip.main.ip_address}"
}

# Network Information
output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = azurerm_subnet.example.name
}

output "network_security_group_name" {
  description = "Name of the network security group"
  value       = azurerm_network_security_group.vm-nsg.name
}