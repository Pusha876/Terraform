resource "azurerm_resource_group" "rg" {
  name     = "day-10-rg"
  location = "westus2"
}

# This is the Network Security Group (NSG) resource
resource "azurerm_network_security_group" "example" {
  name                = (var.environment == "dev" ? "dev-nsg" : "stage-nsg")
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # This will be the dynamic block for security rules
  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
        name                       = security_rule.key
        priority                   = security_rule.value.priority
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = security_rule.value.description_port_range
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        description                = security_rule.value.description
    }
  }

  tags = {
    environment = "Production"
  }
  
}