variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "Terraform-Provisioners"
    Owner       = "DevOps-Team"
    CreatedBy   = "Terraform"
  }
}