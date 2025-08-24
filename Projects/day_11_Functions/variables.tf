variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "Project ALPHA Resource"
}

# Default tags
variable "default_tags" {
    type    = map(string)
    default = {
    company    = "TechCorp"
    managed_by = "terraform"
    }
}

# Environment tags
variable "environment_tags" {
    type    = map(string)
    default = {
    environment  = "production"
    cost_center = "cc-123"
    }
}

variable "storage_account_name" {
  type        = string
  description = "Name of the Azure Storage Account"
  default     = "push TUTORIAL storage1 this should be formatted"
}

variable "allowed_ports" {
  type        = string
  description = "List of allowed ports for the application"
  default     = "80, 443, 3306"
}

variable "environment" {
  type        = string
  description = "the environment name"
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Enter the valid value: dev, staging, prod"
  }
}

variable "vm_size_by_env" {
  type        = map(string)
  default     = {
    dev     = "Standard_B1s"
    staging = "Standard_B2s"
    prod    = "Standard_D2s_v3"
  }
}

variable "vm_size" {
  type        = string
  default     = "Standard_B2s"
  description = "Azure VM size"
  validation {
    condition     = length(var.vm_size) >= 2 && length(var.vm_size) <= 16
    error_message = "The VM size must be between 2 and 16 characters long."
  }
  validation {
    condition     = strcontains(lower(var.vm_size), "standard")
    error_message = "The VM size should contain the word 'Standard'."
  }
}

variable "backup_name" {
  default     = "test_backup"
  type        = string
  validation {
    condition     = endswith(var.backup_name, "_backup")
    error_message = "The backup name must end with '_backup'."
}
  description = "Name of the backup resource"
}

variable "credential" {
  default   = "xyz123"
  type      = string
  sensitive = true
}