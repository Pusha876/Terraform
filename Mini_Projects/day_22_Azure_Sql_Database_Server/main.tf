resource "azurerm_resource_group" "rg-sql" {
  name     = "my-sql-server-rg"
  location = var.location
  tags = var.common_tags
}

# Azure SQL Server (MSSQL)
resource "azurerm_mssql_server" "mssql_server" {
  name                         = "my-mssql-demo-server"
  resource_group_name          = azurerm_resource_group.rg-sql.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssw0rd1234!"
  tags                         = var.common_tags
}

resource "azurerm_mssql_database" "sampledb" {
  name      = "sampledb"
  server_id = azurerm_mssql_server.mssql_server.id
  tags      = var.common_tags
}
