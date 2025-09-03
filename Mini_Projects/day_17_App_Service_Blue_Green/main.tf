resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "canadacentral"
}

resource "azurerm_service_plan" "asp" {
  name               = "${var.prefix}-asp"
  location           = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type            = "Linux"
  sku_name           = "S1"
    tags = {
        environment = "Production"
    }
}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.prefix}-webapp-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
  }

    tags = {
        environment = "Production"
    }
}

resource "azurerm_linux_web_app_slot" "blue" {
  # Slot name only (e.g., "blue"), not the full app name
  name           = "${var.prefix}blue"
  app_service_id = azurerm_linux_web_app.app.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
  }
}

resource "azurerm_app_service_source_control" "scm" {
  app_id   = azurerm_linux_web_app.app.id
  repo_url = "https://github.com/Pusha876/awesome-terraform-day17"
  branch   = "master"
}

resource "azurerm_app_service_source_control_slot" "slot_scm" {
  slot_id  = azurerm_linux_web_app_slot.blue.id
  repo_url = "https://github.com/Pusha876/awesome-terraform-day17"
  branch   = "appServiceSlot_Working_DO_NOT_MERGE"
}