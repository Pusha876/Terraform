variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "canadaeast"
}

variable "vm_size" {
  description = "VM size for linux VMs"
  type        = string
  # DSv2 sizes are often capacity constrained; B2s tends to be widely available and cost-effective
  default     = "Standard_B2s"
}

variable "vnet1_location" {
  description = "Region for VNet1 (peer1). If null, defaults to var.location"
  type        = string
  default     = null
}

variable "vnet2_location" {
  description = "Region for VNet2 (peer2). If null, defaults to var.location"
  type        = string
  default     = null
}

locals {
  vnet1_location = coalesce(var.vnet1_location, var.location)
  vnet2_location = coalesce(var.vnet2_location, var.location)
}
