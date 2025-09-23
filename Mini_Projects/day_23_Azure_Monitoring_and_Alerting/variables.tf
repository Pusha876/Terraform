variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    environment = "development"
    project     = "azure-monitoring"
    owner       = "PushTech"
  }
}

variable "admin_email" {
  description = "Email address of the administrator to receive alerts"
  type        = string
  default     = "djpusha876@gmail.com"
}