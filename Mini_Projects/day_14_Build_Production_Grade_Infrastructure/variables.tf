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
