resource "azurerm_resource_group" "rg" {
  name     = "test-rg"
  location = "australiaeast"
  tags = {
    environment = "dev"
    department = "IT"
}
}