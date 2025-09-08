variable "tags" {
    type        = map(string)
    description = "Tags to apply to Key Vault and related resources."
    default     = {}
}
variable "keyvault_name" {
    type = string
}

variable "location" {
    type = string
}
variable "resource_group_name" {
    type = string
}

variable "service_principal_name" {
    type = string
}

variable "service_principal_object_id" {}
variable "service_principal_tenant_id" {}