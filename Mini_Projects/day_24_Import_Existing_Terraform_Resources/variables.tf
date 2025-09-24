variable "Day" {
  description = "Day number of the mini project"
  type        = string
  default     = "day24"
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "canadaeast"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    environment = "development"
    project     = "import-existing-terraform-resources"
    owner       = "PushTech"
  }
}