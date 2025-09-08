output "keyvault_id" {
    value = azurerm_key_vault.kv.id
}
# SSH public key output
output "ssh_public_key" {
    description = "Public key for use with AKS/VMs."
    value       = tls_private_key.ssh.public_key_openssh
}

# Key Vault secret ID output
output "ssh_private_key_secret_id" {
    description = "ID of the Key Vault secret containing the SSH private key."
    value       = azurerm_key_vault_secret.ssh_private_key.id
}