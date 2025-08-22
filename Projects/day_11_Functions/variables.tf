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