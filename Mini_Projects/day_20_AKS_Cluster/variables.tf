variable "rg_name" {
  type        = string
  description = "The name of the resource group in which to create the AKS cluster"
  default     = "aks-resource-group"
}

variable "location" {
  type        = string
  description = "The Azure region where the resource group will be created"
  default     = "canadacentral"
}

variable "service_principal_name" {
  type        = string
  description = "The name of the service principal to be created for the AKS cluster"
  default     = "aks-service-principal"
}

variable "keyvault_name" {
  type        = string
  description = "The name of the Key Vault to be created"
  default     = "aks-keyvault-push"
}

variable "subscription_id" {
  type        = string
  description = "The subscription ID where resources will be created"
}

variable "common_tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources"
  default     = {
    environment = "dev-training"
    project     = "day_20_AKS_Cluster"
    managed_by  = "Terraform"
    department  = "devops"
  }
}