/*
 * SQL Database modul - Azure SQL adatbázis létrehozása
 */
resource "random_string" "server_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_mssql_server" "server" {
  name                         = "${var.project_name}-${var.environment}-sqlserver"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_password

  tags = var.tags
}

resource "azurerm_mssql_database" "database" {
  name                = "${var.project_name}-${var.environment}-db"
  server_id           = azurerm_mssql_server.server.id
  sku_name            = var.database_sku
  
  zone_redundant      = false

  tags = var.tags
}

# Engedélyezzük az Azure szolgáltatások hozzáférését az SQL szerverhez
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}