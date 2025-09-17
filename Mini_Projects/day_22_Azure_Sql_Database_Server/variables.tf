variable "common_tags" {
  type        = map(string)
  description = "Common tags to be applied to all resources"
  default     = {
    environment = "development"
    owner       = "team-azure"
  } 
}

variable "location" {
  type        = string
  description = "Azure region to deploy resources in"
  default     = "westeurope"
}