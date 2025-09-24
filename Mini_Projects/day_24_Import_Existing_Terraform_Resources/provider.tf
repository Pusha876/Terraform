terraform {
    required_version = ">= 1.5.0"

    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~> 3.0"
        }
    null = {
            source  = "hashicorp/null"
            version = "~> 3.0"
        }
    }
}

provider "azurerm" {
    features {}
    # Auth: uses Azure CLI / environment variables by default
    # Optionally set skip_provider_registration = true if your account lacks permissions
    # skip_provider_registration = true
}