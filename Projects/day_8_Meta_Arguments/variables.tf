variable "environment" {
  type        = string
  default     = "staging"
  description = "the environment for the resources"
}

variable "storage_disk" {
  type        = number
  description = "the size of the storage disk in GB"
  default     = 80
}

variable "is_delete_os_disk_on_termination" {
  type        = bool
  description = "the default is to delete the OS disk when the VM is deleted"
  default     = true
}
 
variable "allowed_locations" {
  type        = list(string)
  description = "List of allowed Azure regions for resource deployment"
  default     = ["Sweden Central", "West Europe", "North Europe"]
}
variable "resource_tag" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {
    environment = "dev-training"
    project     = "day_7_Type_Constraints"
    managed_by  = "Terraform"
    department = "devops"
  }
}

variable "storage_account_name" {
  type        = set(string)
  default     = ["pushtutorialstorage1", "pushtutorialstorage2"]
  description = "Name of the Azure Storage Account"
}

