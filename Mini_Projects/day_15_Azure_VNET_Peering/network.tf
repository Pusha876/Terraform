resource azurerm_resource_group "rg-day15" {
  name     = "rg-day15"
  location = var.location
    tags = {
        environment = "Production"
    }
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "peer1-vnet"
  location            = local.vnet1_location
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.rg-day15.name
  tags                = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "subnet1" {
  name                 = "peer1-subnet"
  resource_group_name  = azurerm_resource_group.rg-day15.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "peer2-vnet"
  location            = local.vnet2_location
  address_space       = ["10.1.0.0/16"]
  resource_group_name = azurerm_resource_group.rg-day15.name
  tags                = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "subnet2" {
  name                 = "peer2-subnet"
  resource_group_name  = azurerm_resource_group.rg-day15.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_virtual_network_peering" "vnet1-to-vnet2" {
  name                      = "vnet1-to-vnet2"
  resource_group_name       = azurerm_resource_group.rg-day15.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
}

resource "azurerm_virtual_network_peering" "vnet2-to-vnet1" {
  name                      = "vnet2-to-vnet1"
  resource_group_name       = azurerm_resource_group.rg-day15.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
}