# main.tf
resource "azurerm_resource_group" "example" {

  lifecycle {
    create_before_destroy = true  # Ensure the resource group is created before destroying the old one
    prevent_destroy = false  # Prevent accidental deletion of the resource group
    # ignore_changes = [account_replication_type]  # Ignore changes to tags
    precondition {
      condition     = contains(var.allowed_locations, var.location)
      error_message = "The specified location is not in the list of allowed locations."
    }
  
  }

  name     = "${var.environment}-resources"
  location = var.allowed_locations[1] # Use a location
  tags    = {
    environment = var.environment
    project     = "day_9_Life_cycle_Rules"
    managed_by  = "Terraform"
    department  = "devops"
  }
}

resource "azurerm_storage_account" "example" {

  for_each                 = var.storage_account_name
  name                     = each.value
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}