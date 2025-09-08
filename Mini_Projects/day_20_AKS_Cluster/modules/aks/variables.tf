variable "location" {

}
 variable "resource_group_name" {}

variable "service_principal_name" {
  type = string
}


variable "ssh_public_key" {
  description = "SSH public key for AKS admin access. Pass from keyvault module output."
  type        = string
}

variable "ssh_private_key_secret_id" {
  description = "Key Vault secret ID for the SSH private key. Pass from keyvault module output."
  type        = string
}

variable "client_id" {}
variable "client_secret" {
  type = string
  sensitive = true
}

variable "aks_tags" {
  type = map(string)
  default = {
      "nodepool-type"    = "system"
      "environment"      = "prod"
      "nodepoolos"       = "linux"
   } 
}