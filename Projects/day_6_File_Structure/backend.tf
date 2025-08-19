 terraform { 
  backend "azurerm" {
                resource_group_name  = "tfstate-day04"
                storage_account_name = "tfstate2428222527"
                container_name       = "tfstate"
                key                  = "terraform.tfstate"
        }
 }