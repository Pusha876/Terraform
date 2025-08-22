locals {
  formatting_name = lower(replace(var.project_name, " ", "-"))
  merge_tags       = merge(var.default_tags, var.environment_tags)
  # Sanitize storage account name: lowercase, remove non-alphanumerics, ensure >=3 chars, then truncate to 24
  # Remove all non-alphanumeric chars using regexall + join (compatible across Terraform versions)
  storage_base      = join("", regexall("[a-z0-9]", lower(var.storage_account_name)))
  storage_norm      = length(local.storage_base) < 3 ? format("%sxyz", local.storage_base) : local.storage_base
  storage_format_name = substr(local.storage_norm, 0, 24)
  # Build a cleaned list of ports from a comma-separated string (handles empty input)
  format_ports      = var.allowed_ports == "" ? [] : [for p in split(",", var.allowed_ports) : trimspace(p)]
  # Build a map of NSG rules the dynamic block expects (key => object with fields)
  nsg_rules         = {
    for idx, port in local.format_ports :
    "allow_${port}" => {
      priority               = 100 + idx
      description_port_range = port
      description            = "Allow port ${port}"
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.formatting_name}-rg"
  location = "East US"
  tags     = local.merge_tags
}

resource "azurerm_storage_account" "example" {

  name                     = local.storage_format_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.merge_tags
}

# This is the Network Security Group (NSG) resource
resource "azurerm_network_security_group" "example" {
  name                = "${local.formatting_name}-nsg"
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
}