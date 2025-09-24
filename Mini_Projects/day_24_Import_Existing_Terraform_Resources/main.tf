resource "azurerm_resource_group" "rg" {
    name     = "${var.Day}-rg"
    location = var.location
    tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
    name                = "${var.Day}-vnet"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "sn" {
    name                 = "default"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_service_plan" "asp" {
    name                = "${var.Day}-plan"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    os_type            = "Linux"
    sku_name            = "B1"
    tags                = var.tags
}

resource "azurerm_linux_web_app" "app" {
    name                = "${var.Day}-app"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    service_plan_id     = azurerm_service_plan.asp.id

    site_config {
        # If you need to set runtime, use app_settings or leave empty for default
    }

    tags = var.tags
}