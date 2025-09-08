variable service_principal_name {
  type        = string
  description = "The name of the service principal to be created for the AKS cluster"
  default     = "aks-service-principal"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to Service Principal resources."
  default     = {}
}