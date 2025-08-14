terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
                resource_group_name  = "tfstate-day04"
                storage_account_name = "tfstate2428222527"
                container_name       = "tfstate"
                key                  = "terraform.tfstate"
        }
  required_version = ">= 0.12"
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}
variable "environment" {
  type        = string
  default     = "staging"
  description = "the environment for the resources"
}

locals {
  common_tags = {
    environment = "dev"
    lob         = "finance"
    project     = "alpha"
    owner       = "pryce"
  }
}

resource "azurerm_storage_account" "example" {
  name                     = "az400storageacct"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location # implicit dependency
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = local.common_tags.owner
    }
}

output "storage_account_name" {
  value       = azurerm_storage_account.example.name
  description = "description of the storage account name"
}
