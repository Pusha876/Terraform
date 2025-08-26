variable "ssh_public_key_path" {
  description = "Path to the SSH public key to inject into VMSS instances"
  type        = string
  default     = "./ssh/id_rsa.pub"
}

variable "environment" {
  description = "Deployment environment tag"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner tag (person or team)"
  type        = string
  default     = "push_productions"
}

# Optional overrideable location (region)
variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "eastus"
}

# Resource group name for the application resources
variable "rg_name" {
  description = "Name of the Resource Group to create/use for app resources"
  type        = string
  default     = "day14-app-rg"
}

# VMSS size and zones
variable "vm_size" {
  description = "VM size (SKU) for the VM Scale Set"
  type        = string
  # Choose a widely available size in East US; override if needed
  default     = "Standard_D2s_v3"
}

variable "zones" {
  description = "Availability zones to use for zonal resources"
  type        = list(string)
  default     = ["1"]
}

# DNS labels control for Public IPs
variable "enable_dns_labels" {
  description = "Global switch: assign DNS labels to Public IPs (deprecated; use enable_lb_dns_label/enable_nat_dns_label)"
  type        = bool
  default     = true
}

variable "enable_lb_dns_label" {
  description = "Enable DNS label on the Load Balancer Public IP"
  type        = bool
  default     = true
}

variable "enable_nat_dns_label" {
  description = "Enable DNS label on the NAT Gateway Public IP"
  type        = bool
  default     = false
}

# Optional explicit DNS labels (leave null to auto-generate stable labels)
variable "lb_domain_name_label" {
  description = "Explicit DNS label for the Load Balancer public IP (optional)"
  type        = string
  default     = null
}

variable "nat_domain_name_label" {
  description = "Explicit DNS label for the NAT Gateway public IP (optional)"
  type        = string
  default     = null
}

# Bump to regenerate auto DNS labels if a conflict occurs
variable "dns_label_salt" {
  description = "Arbitrary salt to force regeneration of auto-generated DNS labels"
  type        = string
  default     = "v1"
}

# Optional user-provided tags
variable "custom_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Base tags for the project
variable "default_tags" {
  description = "Default tags applied to all resources"
  type        = map(string)
  default = {
    project = "day14-vmss"
  }
}

locals {
  common_tags = merge(
    var.default_tags,
    {
      environment = var.environment
      owner       = var.owner
    },
    var.custom_tags
  )
}
