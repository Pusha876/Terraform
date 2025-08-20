terraform {
        backend "azurerm" {
                resource_group_name  = "tfstate-day04"
                storage_account_name = "tfstate1684828945"
                container_name       = "tfstate"
                key                  = "terraform.tfstate"
        }
}