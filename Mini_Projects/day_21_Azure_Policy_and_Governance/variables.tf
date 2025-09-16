variable "location" {
  description = "The Azure region to deploy resources in"
  type        = list(string)
  default     = ["eastus", "westus", "centralus"]
}

variable "vm_size" {
  description = "The size of the Azure VM"
  type        = list(string)
  default     = ["Standard_B1s", "Standard_B2s"]
}

variable "allowed_tags" {
  type        = set(string)
  description = "List of allowed tags for resources"
  default     = ["department", "project"]
}