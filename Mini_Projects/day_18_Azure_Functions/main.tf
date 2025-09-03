resource "azurerm_resource_group" "rg" {
  name     = "day18-rg"
  location = "canadacentral"
}

resource "azurerm_storage_account" "sa" {
  name                     = "pushtechstorageacct${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "example" {
  name                = "example-app-service-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "azurerm_linux_function_app" "example" {
  name                = "example-linux-function-app-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  service_plan_id            = azurerm_service_plan.example.id
  functions_extension_version = "~4"

  site_config {
    application_stack {
      node_version = "18"
  }
}

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME    = "node"
    WEBSITE_RUN_FROM_PACKAGE    = "1"
  }
}