terraform {
	backend "azurerm" {
		resource_group_name  = "day14-rg"
		storage_account_name = "day14tfstate"
		container_name       = "tfstate"
		key                  = "mini/day14-vmss.terraform.tfstate"
	}
}
