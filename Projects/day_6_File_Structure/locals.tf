locals {
  common_tags = {
    environment = var.environment
    lob         = "finance"
    project     = "alpha"
    owner       = "pryce"
  }
}